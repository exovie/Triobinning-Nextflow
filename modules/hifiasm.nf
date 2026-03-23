nextflow.enable.dsl=2

process hifiasm {
    label "hifiasm"
    tag "${hifiasm_name}"

    publishDir "$params.outdir/results/$params.assembly_name/hifiasm/$hifiasm_name", mode: 'copy', pattern: '*'

    input:
        val(hifiasm_name)
        path(yak_parent_1)
        path(yak_parent_2)
        path(longReads)

    output:
        path "*"
        path "${hifiasm_name}.dip.hap1.p_ctg.gfa", emit : hap1_gfa
        path "${hifiasm_name}.dip.hap2.p_ctg.gfa", emit : hap2_gfa
        path "${hifiasm_name}.bp.p_ctg.gfa", emit : merged_gfa
    
    script:
        """
        hifiasm $params.option_hifiasm  -o $hifiasm_name \
		$longReads 2> assembly_merged.asm.log
		hifiasm $params.option_hifiasm -o $hifiasm_name \
		-1 $yak_parent_1 \
		-2 $yak_parent_2 \
		/dev/null 2> assembly_merged.trio.log
        """
}
