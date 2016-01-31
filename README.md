# name2community
Probabilistic inference of religious community from South Asian names: http://dx.doi.org/10.5281/zenodo.45360

This software is a sample implementation (under a GNU Affero General Public license; see LICENSE) of an algorithm that infers likely religious community from South Asian names:

> Susewind, Raphael (2015). What's in a name? Probabilistic inference of religious community from South Asian names. Field Methods 27(4), 319-332. http://dx.doi.org/10.1177/1525822X14564275

While the version of reference is available under the abovementioned link as supplemental material to the journal article, the software might be updated from time to time - the purpose of this repository. Links to empirical applications and new derivative datasets can be found at:  http://data.raphael-susewind.de

This branch - called ngram - leverages an n-gram logic to further improve coverage (at a slight expense of accuracy) as compared to the bare algorithm described in the original version; more on this here: http://www.raphael-susewind.de/blog/2013/namematching-refined

Please read the original article as well as the blog posts mentioned on my website to get a clear picture of the purpose and limitations of this algorithm. You will likely need to produce a sample list of names with known community affiliation drawn from your area of study in order to properly establish the accuracy of the algorithm for your purpose. Likewise, you will need to generate your own master name list using the createnamedb.pl script before you can use guesscommunity.pl itself.

Both scripts are implemented in Perl and run best under Linux, though I have heard of successful runs under Windows as well. They need a fully unicode aware version of Perl (i.e. above 5.8) as well as several modules (in particular WWW::Mechanize and DBD::SQlite). The fuzzy soundex matching relies on python (version 2) scripts developed by Swathanthra Indian Language Processing Applications: http://silpa.org.in/

To run the n-gram logic, you will finally need the SRILM toolkit, or more specifically its "ngram" program which can be downloaded here: http://www.speech.sri.com/projects/srilm/ - follow their instructions to compile it, and then change the path to "ngram" at the beginning of guesscommunity.pl

I am happy to answer your questions about this sample implementation and to hear of your successes and failures. You can reach me at mail@raphael-susewind.de.
