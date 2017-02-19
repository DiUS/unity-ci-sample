# Unity VR provisioning

This repo has two main purposes:

- setting up AWS resources (for Jenkins to run), and
- provisioning a Jenkins box, to build a Unity Gear VR app.

## cloudformation

There are 3 CF stacks, and a shell script each to update them.

### Interesting Bits

- The `jenkins` stack references outputs from the other 2 stacks.
  - `helper.sh` looks after that magic.
- The `vpc` stack sets up a VPC, with a subnet in each Sydney AZ.
- The load balancer in `jenkins` will maintain its IP address, so it doesn't matter where EC2 instances end up, just point to the ELB DNS entry for Jenkins.
- When a new AMI is built, put the ID in `jenkins.sh` and run it.
  - Then, either set the ASG Max Size to 2 for a whole new instance (and re-point the ELB), or
  - terminate it, and the ASG will heal a new instance in. **WARNING:** This will lose all Jenkins history.
- The `jenkins` boxes expect to be accessed with a key called `jenkins` (see the `jenkins` stack parameter `KeyName`). You'll have to make that yourself, for ssh access.

## packer

The Jenkins job `jenkins-ami` runs `packer`, which runs `ansible`, which installs everything, and outputs an AMI.

See AWS Console -> EC2 -> AMIs, for what's been built already.

### Interesting Bits

- Look in `packer/ansible/roles`. There is no actual magic ;)
- See `fetch_roles.sh` for roles that you inexplicably can't find.
- To update Unity, Android Package Manager, or Packer versions, look in `jenkins.yml`.
- The `android-sdk` role also has android-related version numbers in it. Check it out.
- The `unity` role does a bit of surprising stuff. No magic, though.

## Jenkins

Not part of using the repo, but these files live in the repo. There's a jenkins job called `jenkins-export`, which saves all the jenkins config (including encrypted credentials) to S3. When a new box fires up, config will be imported, so everything should be how you left it (minus job history, of course).

Please run `jenkins-export` when you change jenkins jobs :)
