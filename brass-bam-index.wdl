task samtoolsSortTask{
    File inputBAM

    String sortedBAM = basename(inputBAM, ".bam") + ".sorted.bam"

    command {
        samtools sort -m 20G -@ 4 -o ${sortedBAM} ${inputBAM} && \
        samtools index ${sortedBAM}
    }
    runtime {
        docker : "erictdawson/svdocker"
        memory : "24 GB"
        cpus : 4
        preemptible : 3
    }
    output{
        File outputBAM="${sortedBAM}"
        File outputBAI="${sortedBAM}.bai"
    }
}

workflow samtoolsSort {
    File inputBAM
  
    call samtoolsSortTask{
        input:
            inputBAM=inputBAM
    }
}
