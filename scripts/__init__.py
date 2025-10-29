#import subprocess

#def serve():
#  subprocess.run(['mkdocs','serve'])

#def build():
#  subprocess.run(['mkdocs','build'])

#def unit_test():
#  subprocess.run(['poetry','run','test'])

#def empty():
#  pass

import subprocess
import os

personas_to_build = ["ibmer", "partner"]


def serve():
    subprocess.run(['mkdocs', 'serve'])


def build():
    for persona_to_build in personas_to_build:
        print(f"Building for {persona_to_build}")
        subprocess.run(['mkdocs', 'build', '--verbose', '--clean', '--strict', '-d', f'site/{persona_to_build}'],
                       env={
                           **os.environ.copy(),
                           "CIC_PERSONA": persona_to_build
                       }).check_returncode()

    # Write a single very small file for the probes to use
    with open("site/index.html", "w") as fp:
        fp.write("<h1>It's alive!</h1>")


def unit_test():
    subprocess.run(['poetry', 'run', 'test'])


def empty():
    pass
