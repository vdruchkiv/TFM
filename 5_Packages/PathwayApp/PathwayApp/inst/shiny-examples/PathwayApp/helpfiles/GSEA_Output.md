Understanding GSEA
==================

Given gene expressions of two groups one can calculate and order logRatios that are indicators for the degree of correlation and separation between the groups. Let’s denote the ordered list $L$.

The objective of GSEA is to determine whether genes annotated to a certain pathway $S$ are randomly distributed along the list $L$ or rather agglomerate to the top or tail of it. One would expect that genes related to phenotype difference show the later distribution.  

GSEA consists of three steps:

1. Calculate enrichment score (ES). The score is calculated walking along $L$ and increasing when finding a gene from the node of interest and decreasing otherwise. The obtained score is a Kolmogorov-Smirnov-like statistic.

2. Estimation of the significance level for ES. The nominal P value is obtained by **permutating gene labels** and recalculating ES value. Given the distribution of ES values and observed value it is straightforward calculate P value.

3. Adjustment of the nominal P value for multiple comparisons. User can determine adjustment method to be used.

<img src="GSEA_Method.jpg" width="300" style="display:block; margin:auto;" />

The output table includes following statistics of interest:


* **ES**: Enrichment Score for the set of genes. Degree by which the gene set is overexpressed in head or tail of the ordered list of genes. 
* **NES**: Normalized enrichment score. NES considers all analysed gene sets (there size and correlation with the expression data) and makes the comparison between the genes possible.  
* **pvalue**: Nominal P value.
* **p.adjust**. Adjusted P value.
* **q-values**. Expected proportion of false positives incurred when calling that feature signiﬁcant. For example, if gene X has a q-value of 0.025 it means that 2.5% of genes that show p-values at least as small as gene X are false positives.
* **leading_edge**:
    * **Tags**: Percentage of gene occurrences from the specific gene set before (for positive ES) or after (for negative ES) the pic of running enrichment score. This value indicates the percentage of genes that contribute to the enrichment score.
    * **List**: Percentage of all genes in the ordered list before or after the pic. This value indicates where the pic occurs.
    * **Signal**. The strength of the enrichment signal that combines both tags and list.
* **rank**. The position of the pic in the ordered list. The most interesting gene sets reach their maximum at the beginning or at the end of the list. Thus, their value is either very small or very large.

