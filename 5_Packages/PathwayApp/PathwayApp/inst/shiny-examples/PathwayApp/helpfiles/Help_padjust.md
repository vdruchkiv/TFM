From R manual `p.adjust{stats}`
===============================

The adjustment methods include the Bonferroni correction in which the
p-values are multiplied by the number of comparisons. Less conservative
corrections are also included by Holm (1979), Hochberg (1988)
(`hochberg`), Hommel (1988) (`hommel`), Benjamini and Hochberg (1995)
(`BH` or its alias `fdr`), and Benjamini, Yekutieli, and others (2001)
(`BY`), respectively. A pass-through option (`none`) is also included.

The first four methods are designed to give strong control of the
family-wise error rate. There seems no reason to use the unmodified
Bonferroni correction because it is dominated by Holm's method, which is
also valid under arbitrary assumptions. Hochberg's and Hommel's methods
are valid when the hypothesis tests are independent or when they are
non-negatively associated (Sarkar (1998); Sarkar and Chang (1997)).
Hommel's method is more powerful than Hochberg's, but the difference is
usually small and the Hochberg p-values are faster to compute. The `BH`
(aka `fdr`) and `BY` method of Benjamini, Hochberg, and Yekutieli
control the false discovery rate, the expected proportion of false
discoveries amongst the rejected hypotheses. The false discovery rate is
a less stringent condition than the family-wise error rate, so these
methods are more powerful than the others.

References
==========

Benjamini, Yoav, and Yosef Hochberg. 1995. “Controlling the False
Discovery Rate: A Practical and Powerful Approach to Multiple Testing.”
*Journal of the Royal Statistical Society: Series B (Methodological)* 57
(1). Wiley Online Library: 289–300.

Benjamini, Yoav, Daniel Yekutieli, and others. 2001. “The Control of the
False Discovery Rate in Multiple Testing Under Dependency.” *The Annals
of Statistics* 29 (4). Institute of Mathematical Statistics: 1165–88.

Hochberg, Yosef. 1988. “A Sharper Bonferroni Procedure for Multiple
Tests of Significance.” *Biometrika* 75 (4). Oxford University Press:
800–802.

Holm, Sture. 1979. “A Simple Sequentially Rejective Multiple Test
Procedure.” *Scandinavian Journal of Statistics*. JSTOR, 65–70.

Hommel, Gerhard. 1988. “A Stagewise Rejective Multiple Test Procedure
Based on a Modified Bonferroni Test.” *Biometrika* 75 (2). Oxford
University Press: 383–86.

Sarkar, Sanat K. 1998. “Some Probability Inequalities for Ordered Mtp2
Random Variables: A Proof of the Simes Conjecture.” *Annals of
Statistics*. JSTOR, 494–504.

Sarkar, Sanat K, and Chung-Kuei Chang. 1997. “The Simes Method for
Multiple Hypothesis Testing with Positively Dependent Test Statistics.”
*Journal of the American Statistical Association* 92 (440). Taylor &
Francis: 1601–8.
