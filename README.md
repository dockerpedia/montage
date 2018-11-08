# montage

### How to run

First, you must run the container

```
docker run -d --rm -it --name montage dockerpedia/montage
```

Next, you must enter the container. You can confirm that you are inside of the container by the prompt

```
root@docker-instance:~# docker exec -ti -u workflow:workflow montage bash
workflow@a0f861e6fbc4:~$ 
workflow@a0f861e6fbc4:~/$ bash workflow.sh
```

And follow the instructions of Pegasus


### Troubleshooting

Workflow has hardware requirements, you can edit these requirements on the file named: workflow-generator.

```
        mem_mb = mem_gb * 1000
        self.addProfile(Profile(Namespace.CONDOR,
                                key="request_cpus",
                                value=str(cores)))
        self.addProfile(Profile(Namespace.PEGASUS,
                                key="pmc_request_cpus",
                                value=str(cores)))
        self.addProfile(Profile(Namespace.CONDOR,
                                key="request_memory",
                                value=str(mem_mb)))
        self.addProfile(Profile(Namespace.PEGASUS,
                                key="pmc_request_memory",
                                value=str(mem_mb)))
        self.addProfile(Profile(Namespace.CONDOR,
                                key="request_disk",
                                value=str(20*1024*1024)))
```                                

If the hardware does not meet the requirements your work will be idle. You can use the command ```condor_q -better-analyze```. Here is an example:


```
workflow@a0f861e6fbc4:~/soykb$ condor_q -better-analyze
The Requirements expression for your job is:

    ( isUndefined(GLIDEIN_Entry_Name) ) && ( TARGET.Arch == "X86_64" ) &&
    ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) &&
    ( TARGET.Memory >= RequestMemory ) && ( TARGET.Cpus >= RequestCpus ) &&
    ( TARGET.HasFileTransfer )

Your job defines the following attributes:

    RequestCpus = 2
    RequestDisk = 20971520
    RequestMemory = 3000

The Requirements expression for your job reduces to these conditions:

         Slots
Step    Matched  Condition
-----  --------  ---------
[0]           2  isUndefined(GLIDEIN_Entry_Name)
[1]           2  TARGET.Arch == "X86_64"
[3]           2  TARGET.OpSys == "LINUX"
[5]           2  TARGET.Disk >= RequestDisk
[7]           2  TARGET.Memory >= RequestMemory
[9]           0  TARGET.Cpus >= RequestCpus
```
