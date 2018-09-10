task brassGroupTask{
    File mergedBrmBAM
    String outBase

    command {
        brass-group ${mergedBrmBAM} -o ${outBase}.brass_PON.groups
    }

    runtime{
        docker : "erictdawson/cgp-docker"
        cpu : 4
        memory : "100 GB"
        preemptible : 1
        disks : "local-disk 1000 HDD"
    }

    output{
        File brassGroupGZ = "${outBase}.brass_PON.groups"
    }
}

task bgzipAndTabixTask{
    File brassPONGroupsGZ
    String outBase
    command{
        ( zgrep '^#' ${brassPONGroupsGZ};\
        zcat ${brassPONGroupsGZ} | \
        perl -ane 'next if ($_=~/^#/); printf "%s%s%s%s\t%s\n", $F[0],$F[1],$F[4],$F[5],join("\t",@F[1..$#F]);' | \
        sort -k1,1 -k3,3n -k4,4n -k7,7n -k8,8n ) > ${outBase}.brass.srt.groups && \
        bgzip -c ${outBase}.brass.srt.groups > ${outBase}.brass.srt.groups.gz && \
        tabix -s 1 -b 3 -e 4 -0 ${outBase}.brass.srt.groups.gz
    }

    runtime{
        docker : "erictdawson/cgp-docker"
        cpu : 2
        memory : "14 GB"
        disks : "local-disk 1000 HDD"
    }

    output{
        File brassPONGZ = "${outBase}.brass.srt.groups.gz"
        File brassPONTBI = "${outBase}.brass.srt.groups.gz.tbi"
    }
}

workflow generateBrassFilterFile{
    File brassMergedBRMBAM
    String outBase

    call brassGroupTask{
        input:
           mergedBrmBAM=brassMergedBRMBAM,
           outBase=outBase
    }

    call bgzipAndTabixTask{
        input:
            brassPONGroupsGZ=brassGroupTask.brassGroupGZ,
            outBase=outBase
    }


}

