Each folder prefixed by "myGA_" is suffixed by the corresponsding stage that the code was in at the time.
For example, the folder labled "myGA_0" is the first stage of the code.
Within each of these folders are attempt folders.
Each attempt folder corresponds to a version of the respective stage of the code.
Within each attempt folder there may be any combination of the following fodlers:
	"backup", "html", "images", "misc", "testing", "unused"

The "backup" folder contains .asv files which are matlab back-up files.
The "html" folder contains published matlab files.
The "images" folder contains "results" folders.
	Results folders are prefixed by the corresponding trial run.
		(i.e. - Trial one, technique one = A1
		        Trial one, technique two = A2
		        
		        Trial two, technique one = C1
		        Trial oen, technique two = C2)

The "misc" folder contains miscellaneous files (mostyl files produced by testing code)
The "testing" folder contains code used for sub-testing problems within a respective attempt.
The "unused" folder contains code that was not used, but was sometimes referenced during implementation.



[User Guide - Global Optimization Toolbox](https://www.mathworks.com/help/pdf_doc/gads/gads_tb.pdf)