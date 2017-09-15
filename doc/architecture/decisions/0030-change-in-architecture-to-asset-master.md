# 30. Change in architecture to Asset Master

Date: 2017-09-15

## Status

Accepted

## Context

Traditionally we built an "asset-master-1" instance with a large disk, and exported
that disk as an NFS share.

The "backend", "whitehall-backend" and "asset-slave" instances all mounted this NFS
share for the tasks they needed to do (uploading files for the backend machines, and
making backups on the asset-slave machines).

In AWS, we have the option to use [Elastic File System (EFS)](https://aws.amazon.com/efs).
This is an autoscaling filesystem so we do not have to manage disk space, and is independent
to any instance. Each instance would have to mount this filesystem in the same way as NFS,
but it is not managed by us.

## Decision

We will create an EFS resource and expose the mount using our internal Route 53 DNS. We will allow
the required machines to mount the resource using Security Groups.

The backend and whitehall-backend instances will mount as usual, and the asset-master will also
mount the disk like an external share.

The asset-master is required to mount because it moves files about the filesystem after running
virus scans.

A decision has yet to be made on the role of the asset-slave, as we could potentially move
these tasks onto the asset-master (pushing backups to an S3 bucket, for example).

## Consequences

No more disk management on the asset-master.

Architecture has changed so there may be further work related to how do we backups of
attachments.
