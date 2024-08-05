#!/usr/bin/python3
""" do_deploy_web_static module """
from fabric.api import *
from os.path import exists
env.hosts = ['52.3.250.188', '52.23.212.81']


def do_deploy(archive_path):
    """deply filr to server
    Args:
        archive_path: path of the file.
    Returns:
        False if fail or filr not exists otherwise True.
    """
    if not exists(archive_path):
        return False

    sPath = archive_path.replace("versions", "/tmp")
    r = put(archive_path, sPath)
    if r.failed:
        return False
    fName = sPath.split('/')[-1].split('.')[0]
    fPath = "/data/web_static/releases/{}".format(fName)
    r = run("mkdir -p {}".format(fPath))
    if r.failed:
        return False
    r = run("tar -xzf {} -C {}/".format(sPath, fPath))
    if r.failed:
        return False
    r = run("rm {}".format(sPath))
    if r.failed:
        return False
    sPath = fPath
    r = run("mv {}/web_static/* /data/web_static/releases/{}/".
            format(sPath, fName))
    if r.failed:
        return False
    r = run("rm -rf {}/web_static".format(sPath))
    if r.failed:
        return False
    r = run("rm -rf /data/web_static/current")
    if r.failed:
        return False
    r = run("ln -s {}/ /data/web_static/current".format(fPath))
    if r.failed:
        return False
    return True
