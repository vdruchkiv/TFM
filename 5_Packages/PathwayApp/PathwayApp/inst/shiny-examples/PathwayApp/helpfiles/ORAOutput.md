Understanding ORA output
========================

Statistical test is based on the hypogeometrical distribution: 

$$p = 1 - \displaystyle\sum_{i = 0}^{k-1}\frac{{M \choose i}{{N-M} \choose {n-i}}} {{N \choose n}}$$

In this equation, $N$ is the total number of genes in the background distribution, $M$ is the number of genes within that
distribution that are annotated to the node of interest, $n$ is the size of the list of genes of interest and $k$ is the number of genes within that list which are annotated to the node. 


El valor de P obtingut amb aquesta formula dona la probabilitat de veure el nombre $x$ de gens de la llista relacionats amb la ruta específica en la llista del nombre total de gens $n$ donat la proporció de gens relacionats amb aquesta ruta en la distibucó de fons.
 


- **Description**. Name of the pathway: either GO, KEGG or Reactome;
- **GeneRatio**. Fraction: $\displaystyle\frac{\mbox{Number of differencially expressed genes in a pathway}}{\mbox{Total number of differencilly expressed genes}}=\frac{M}{N}$; 
- **BgRatio**. Fraction: $\displaystyle\frac{\mbox{Number of genes annotated to the node of interest}}{\mbox{Total number of genes in the beackground distribution}}=\frac{k}{n}$;
- **pvalue**. P-Value obtained with formula for hypogeometrical distribution.
- **p.adjust**. P-Value adjusted via method specified by the user.
* **q-values**. Expected proportion of false positives incurred when calling that feature signiﬁcant. For example, if gene X has a q-value of 0.025 it means that 2.5% of genes that show p-values at least as small as gene X are false positives.
