nextflow.enable.dsl=2

process merging_short_reads {
    label "merging_short_reads"
    tag "${sample_name}"  
    
    publishDir "$params.outdir/results/$params.assembly_name/merging_short_reads/$sample_name", mode: 'copy', pattern: '*.fastq.gz'
    
    input:
        val(sample_name)
        path(R1)
        path(R2)

    
    output:
        path("${sample_name}.fastq.gz"), emit: merged_illumina_reads  

    script:
        """
        cat $R1 $R2 > ${sample_name}.fastq.gz
        """
}


process yak {
    label "yak"
    tag "${yak_name}"

    publishDir "$params.outdir/results/$params.assembly_name/yak/$yak_name", mode: 'copy', pattern: '*.yak'

    input:
		val(yak_name)
        path(merged_parent)  

    output:
        path("${yak_name}.yak"), emit: yak_file

    script:
        """
        echo "$params.outdir"
        echo "$params.assembly_name"
        
        yak count $params.option_yak -o ${yak_name}.yak $merged_parent
        """
}
