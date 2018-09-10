task getSampleName{
    File BAM

    command {
        samtools view -H ${BAM} | grep -o "SM:[\.0-9A-Z\-]*" | sort | uniq 
    }

    output{
        String sampleName = read_lines(stdout())[0]
    }

    runtime{
        docker : "erictdawson/svdocker"
        cpu : 1
        memory : "1 GB"
        preemptible : 3
        disks : "local-disk 1000 HDD"
    }
}

task generateBrassDiscordBam{
    File inputBAM
    File inputBAMIndex
    File inputBAMBas
    String sampleName

    String iLocBAM = basename(inputBAM)
    String iLocBAI = basename(inputBAMIndex)
    String iLocBAS = basename(inputBAMBas)

    String resultsDirName = sub(sampleName, "SM:", "")


    command {
        ln -s ${inputBAM} ${iLocBAM} && \
        ln -s ${inputBAMIndex} ${iLocBAI} && \
        ln -s ${inputBAMBas} ${iLocBAS} && \
        brassI_np_in.pl `pwd` 1 ${iLocBAM}
    }


    runtime{
        docker : "erictdawson/cgp-docker"
        cpu : 1
        memory : "3 GB"
        preemptible : 2
        disks : "local-disk 1000 HDD"
    }

    output{
        File brassBRMBAM = "${resultsDirName}/${resultsDirName}.brm.bam"
        File brassBRAMBAMIndex = "${resultsDirName}/${resultsDirName}.brm.bam.bai"
    }

}

workflow brassGenerateBRMBAM{
    File inputBAM
    File inputBAMIndex
    File inputBAMBas

    call getSampleName{
        input:
           BAM=inputBAM 
    }

    call generateBrassDiscordBam{
        input:
            inputBAM=inputBAM,
            inputBAMIndex=inputBAMIndex,
            inputBAMBas=inputBAMBas,
            sampleName=getSampleName.sampleName
    }
}
