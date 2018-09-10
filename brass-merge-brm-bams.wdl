task mergeBrmBamsTask{
    Array[File] brmBAMs
    Array[File] brmBAMIndexes
    String outBase



    command {

        for i in ${sep=' ' brmBAMs}; do
            ln -s $i $(basename $i)
            echo "$(basename $i)" >> bams.txt
        done
        for i in ${sep=' ' brmBAMIndexes}; do
            ln -s $i $(basename $i)
        done
        samtools merge -@4 -b bams.txt ${outBase}.merged.brm.bam &&
        samtools index ${outBase}.merged.brm.bam
    }

    runtime{
        docker : "erictdawson/svdocker"
        cpu : 4
        memory : "14 GB"
        disks : "local-disk 600 SSD"
    }

    output{
        File mergedBRMBAM = "${outBase}.merged.brm.bam"
        File mergedBRMBAI = "${outBase}.merged.brm.bam.bai"
    }
}

workflow brassMergeWorkflow{
    Array[File] brmBAMs
    Array[File] brmBAMIndexes
    String outBase

    call mergeBrmBamsTask{
        input:
            brmBAMs=brmBAMs,
            brmBAMIndexes=brmBAMIndexes,
            outBase=outBase
    }

}
