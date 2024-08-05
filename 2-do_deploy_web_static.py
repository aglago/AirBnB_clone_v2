#!/usr/bin/python3
"""
Compress web static package
"""

from fabric.api import env, run, put
import os

env.hosts = ['52.3.250.188', '52.23.212.81']

def do_deploy(archive_path):
    """Deploy web files to server
    """
    if not os.path.exists(archive_path):
        return False

    try:
        # Extract filename and folder name
        archive_file = os.path.basename(archive_path)
        file_name = archive_file.split('.')[0]
        release_dir = f"/data/web_static/releases/{file_name}/"

        # Upload the archive to /tmp/ on the server
        put(archive_path, f"/tmp/{archive_file}")

        # Create release directory
        run(f"mkdir -p {release_dir}")

        # Uncompress the archive to the release directory
        run(f"tar -xzf /tmp/{archive_file} -C {release_dir}")

        # Move the contents out of the uncompressed folder
        run(f"mv {release_dir}web_static/* {release_dir}")
        run(f"rm -rf {release_dir}web_static")

        # Remove the archive from /tmp/
        run(f"rm /tmp/{archive_file}")

        # Remove the old symbolic link
        run("rm -rf /data/web_static/current")

        # Create a new symbolic link to the new release
        run(f"ln -s {release_dir} /data/web_static/current")

        return True
    except Exception as e:
        return False
