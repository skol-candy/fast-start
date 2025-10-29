---
Title: Setup the mirror host
hide:
  - toc
---

## Add storage to the bastion host

The mirror registry will be installed on the bastion host. Mirroring OpenShift platform and operator images and running the mirror registry on the same host requires tens of gigabytes of disk space. The initial disk space on the bastion host is not sufficient, you need to make more storage available.

1. Log into the vSphere console.

   Use the vCenter Console URL, username and password from your reservation.

2. Add a 500GB disk to the bastion virtual machine.

   1. Click on the second icon at the top of the left tree view.
   1. Expand things until you click on the bastion machine.
   1. Click the Edit Settings button on the top toolbar.
   1. Click Add New Device, choose Hard Disk.
   1. Change the size to 500 GB for the "New Hard disk", then click OK.

3. Open a Terminal and log in the bastion host.

4. List the block devices and identify the new disk.

   ```sh
   lsblk
   ```

   ```{.text .no-copy title="Example output"}
   NAME                  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   sda                     8:0    0   50G  0 disk
   ├─sda1                  8:1    0  600M  0 part /boot/efi
   ├─sda2                  8:2    0    1G  0 part /boot
   └─sda3                  8:3    0 48.4G  0 part
     ├─rhel_bastion-root 253:0    0 43.4G  0 lvm  /
     └─rhel_bastion-swap 253:1    0    5G  0 lvm  [SWAP]
   sdb                     8:16   0  500G  0 disk
   ```

5. List the volume groups.

   ```sh
   sudo vgs
   ```

   ```{.text .no-copy title="Example output"}
   VG           #PV #LV #SN Attr   VSize  VFree
   rhel_bastion   1   2   0 wz--n- 48.41g    0
   ```

6. Extend volume group `rhel_bastion` with the new block device `/dev/sdb`.

   ```sh
   sudo vgextend rhel_bastion /dev/sdb
   ```

   ```{.text .no-copy title="Example output"}
   Physical volume "/dev/sdb" successfully created.
   Volume group "rhel_bastion" successfully extended
   ```

7. Extend the size of the root logical volume to 100% of it's unallocated size.

   ```sh
   sudo lvextend -l +100%FREE /dev/rhel_bastion/root
   ```

   ```{.text .nocopy title="Example output"}
   Size of logical volume rhel_bastion/root changed from 43.41 GiB (11113 extents) to <143.41 GiB (36712 extents).
   Logical volume rhel_bastion/root successfully resized.
   ```

8. Extend the size of the root filesystem.

   ```sh
   sudo xfs_growfs /
   ```

   ```{.text .nocopy title="Example output"}
   meta-data=/dev/mapper/rhel_bastion-root isize=512    agcount=4, agsize=2844928 blks
            =                       sectsz=512   attr=2, projid32bit=1
            =                       crc=1        finobt=1, sparse=1, rmapbt=0
            =                       reflink=1    bigtime=0 inobtcount=0
   data     =                       bsize=4096   blocks=11379712, imaxpct=25
            =                       sunit=0      swidth=0 blks
   naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
   log      =internal log           bsize=4096   blocks=5556, version=2
            =                       sectsz=512   sunit=0 blks, lazy-count=1
   realtime =none                   extsz=4096   blocks=0, rtextents=0
   data blocks changed from 11379712 to 37593088
   ```

## Install the mirror registry

To ensure secure communication with image registries, which require HTTPS, we must create a TLS certificate for the mirror registry. While the mirror-registry command can generate a TLS certificate automatically, it does not provide sufficient control over the subject and subject alternate name fields of the certificate.

1. Create a working directory.

   ```sh
   mkdir ocpinstall
   ```

2. Generate a self-signed TLS certificate.

   ```sh
   openssl req -newkey rsa:4096 -nodes -sha256 -keyout /home/admin/ocpinstall/quay.key \
       -x509 -out /home/admin/ocpinstall/quay.crt -days 3650 \
       -subj "/O=gym,CN=registry.gym.lan" \
       -addext "subjectAltName = DNS:registry.gym.lan,IP:192.168.252.2"
   ```

3. Create a temporary directory

   ```sh
   MIRROR_DIR=$(mktemp -d)
   ```

4. Download the quay.io archive.

   ```sh
   curl -Lo ${MIRROR_DIR}/mirror-registry.tar.gz \
       https://mirror.openshift.com/pub/cgw/mirror-registry/latest/mirror-registry-amd64.tar.gz
   ```

5. Get into the temporary directory

   ```sh
   cd ${MIRROR_DIR}
   ```

6. Extract the quay.io archive.

   ```sh
   tar xf mirror-registry.tar.gz
   ```

7. Run the install command.

   ```sh
   ./mirror-registry install --quayHostname 192.168.252.2 \
       --initUser admin --initPassword QuayForAll! \
       --sslKey /home/admin/ocpinstall/quay.key --sslCert /home/admin/ocpinstall/quay.crt
   ```

8. Return to the install directory

   ```sh
   cd ~/ocpinstall
   ```

9. Ensure the mirror registry is accessible on port `8443`.

```sh
sudo firewall-cmd --add-port 8443/tcp --permanent
sudo firewall-cmd --reload
```

10. Test connectivity.

```sh
curl -sk https://192.168.252.2:8443/health/instance | jq
```

```{.json .no-copy title="Example output"}
{
  "data": {
    "services": {
      "auth": true,
      "database": true,
      "disk_space": true,
      "registry_gunicorn": true,
      "service_key": true,
      "web_gunicorn": true
    }
  },
  "status_code": 200
}
```

## Make the RHCOS VMware OVA available

When installing OpenShift using IPI, by default the installer downloads the Red Hat CoreOS VMware OVA from the internet. To complete an air-gapped installation, you must first obtain the OVA image and make it accessible via HTTP (HTTPS is not necessary).

1. Install the `httpd` package.

   ```sh
   sudo dnf install -y httpd
   ```

2. Start and enable the service.

   ```sh
   sudo systemctl enable httpd --now
   ```

3. Ensure the http port is accessible.

   ```sh
   sudo firewall-cmd --permanent --add-service http
   sudo firewall-cmd --reload
   ```

4. Download the OVA.

   ```sh
   OCP_VERSION=4.18
   ```

   ```sh
   curl -Lo rhcos-vmware.x86_64.ova \
       https://mirror.openshift.com/pub/openshift-v4/amd64/dependencies/rhcos/${OCP_VERSION}/latest/rhcos-vmware.x86_64.ova
   ```

5. Move the OVA into `/var/www/html`.

   ```sh
   sudo mv rhcos-vmware.x86_64.ova /var/www/html
   ```

6. Restore the default SELinux context on the directory so that the httpd service can access the ova.

   ```
   sudo restorecon -Rv /var/www/html
   ```
