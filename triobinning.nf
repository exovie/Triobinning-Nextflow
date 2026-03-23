#!/usr/bin/env nextflow

include { merging_short_reads as MERGE_PARENT_1 ; merging_short_reads as MERGE_PARENT_2 ; yak as YAK_1 ; yak as YAK_2 } from './modules/yak.nf'
include { hifiasm } from './modules/hifiasm.nf'
include { gfa_to_fa as GFA_TO_FA_1 ; gfa_to_fa as GFA_TO_FA_2 ; gfa_to_fa as GFA_TO_FA_3 ; scaffolding as SCAFFOLDING_1 ; scaffolding as SCAFFOLDING_2 } from './modules/scaffolding.nf'
include { bbtools as BBTOOLS_1 ; bbtools as BBTOOLS_2 ; bbtools as BBTOOLS_3 ; busco as BUSCO_1 ; busco as BUSCO_2 ; busco as BUSCO_3} from './modules/quality.nf'

workflow {
    longReads=Channel.fromPath(params.genome)
    shortReads_parent_1_R1=Channel.fromPath(params.illumina_p1_R1)
    shortReads_parent_1_R2=Channel.fromPath(params.illumina_p1_R2)
    shortReads_parent_2_R1=Channel.fromPath(params.illumina_p2_R1)
    shortReads_parent_2_R2=Channel.fromPath(params.illumina_p2_R2)
    shortReads_parent_1=Channel.fromPath(params.illumina_p1)
    shortReads_parent_2=Channel.fromPath(params.illumina_p2)
    yak_parent_1=Channel.fromPath(params.yak_p1)
    yak_parent_2=Channel.fromPath(params.yak_p2)

    //merged_parent_1 = MERGE_PARENT_1("parent_1", shortReads_parent_1_R1, shortRreads_parent_1_R2)
    //merged_parent_2 = MERGE_PARENT_2("parent_2", shortReads_parent_2_R1, shortRreads_parent_2_R2)
    //yak_parent_1 = YAK_1("yak_parent_1", shortReads_parent_1)
    //yak_parent_2 = YAK_2("yak_parent_2", shortReads_parent_2)

    triobinning = hifiasm(Channel.value(params.assembly_name), yak_parent_1, yak_parent_2, longReads)

    hap1_fasta = GFA_TO_FA_1("hap1", triobinning.hap1_gfa)
    hap2_fasta = GFA_TO_FA_2("hap2", triobinning.hap2_gfa)
    merged_fasta = GFA_TO_FA_3("merged", triobinning.merged_gfa)
    scaffolded_hap_1 = SCAFFOLDING_1("hap_1_against_hap2", hap1_fasta.fasta_haplotype, hap2_fasta.fasta_haplotype)
    scaffolded_hap_2 = SCAFFOLDING_2("hap_2_against_hap1", hap2_fasta.fasta_haplotype, hap1_fasta.fasta_haplotype)

    hap_1 = BBTOOLS_1("bbtools_hap_1", scaffolded_hap_1.scaffolded_haplotype)
    hap_2 = BBTOOLS_2("bbtools_hap_2", scaffolded_hap_2.scaffolded_haplotype)
    merged = BBTOOLS_3("bbtools_merged", merged_fasta)
    haplotype_1 = BUSCO_1("busco_hap1", scaffolded_hap_1.scaffolded_haplotype)
    haplotype_2 = BUSCO_2("busco_hap2", scaffolded_hap_2.scaffolded_haplotype)	
    merged_asm = BUSCO_3("busco_merged", merged_fasta)
}
