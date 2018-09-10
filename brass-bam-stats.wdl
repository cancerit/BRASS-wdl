task brassBAMStatsTask{
    File inputBAM
    File inputBAMIndex

    String basName = basename(inputBAM) + ".bas"


    command {
	    bam_stats -i ${inputBAM} -o ${basName}
    }

    runtime{
        docker : "erictdawson/cgp-docker"
        cpu : 1
        memory : "3 GB"
        disks : "local-disk 1000 HDD"
        preemptible : 2
    }

    output{
        File brassBAMBas = "${basName}"
    }

}

workflow brassBAMStats{
    File inputBAM
    File inputBAMIndex

    call brassBAMStatsTask{
        input:
            inputBAM=inputBAM,
            inputBAMIndex=inputBAMIndex
    }
}
