**The Source-Informed Segmentation Plugin**

**for Brainstorm Toolbox**

by **Ali Haddad**

1.  **About the Plugin:**

This plugin employs the *Source-Informed Segmentation Algorithm* \[1\]
in the temporal segmentation of EEG files within the Brainstorm toolbox
\[2\]. The plugin segments the EEG data in the files passed to it and
returns a new set of files, with the processed EEG data marked by the
detected segment boundaries as extended events, which can be found in
the (.Event) field of each processed file. Furthermore, the parameters
and secondary outcomes of the *Source-Informed Segmentation Algorithm*
and other options used by the plugin are saved to the (.SISegment) field
added to each of these processed files (see section 6). The processed
files are added back to the Brainstorm workspace. Additionally, the
plugin collects various statistics which summarize the performed
segmentation processes. The statistics are displayed after the
completion of all segmentation processes, and can optionally be saved to
a user selected file.

The plugin can be applied either to one set of files, to be processed
and statistically summarized together, or to two sets of files, to be
equivalently processed then compared using the same statistical
measures.

For citation, see \[1\] below. The Source-Informed Segmentation Plugin
for Brainstorm Toolbox can be found
[here](http://eceweb1.rutgers.edu/~laleh/#/database).

1.  **Installing the Plugin:**

Copy the two files:

“process\_SISegmentationMD.m” and “process\_SISegmentationMD2.m”,

intended to perform *Source-Informed Segmentation* under “Process1” and
“Process2” tabs, respectively, to the Brainstorm user process folder:

“$HOME/.brainstorm/process”.

1.  **Running the Plugin:**

-   Run the “brainstorm” toolbox from MATLAB’s command window.

-   Select the EEG files to be processed from the “Functional data” pane
    <img src="./media/image3.png" style="width:0.29in;height:0.26in" />.

<img src="./media/image3.png"
style="width:2.66667in;height:3.98461in" />

-   Drag the selected files then drop them in the “Files to process:
    Data \[#\]” pane of the “Process1” tab, for them to be processed
    together,

<img src="./media/image4.png"
style="width:2.66667in;height:3.96928in" />

or either the “Files A: Data \[#\]” or “Files B: Data \[#\]” pane of the
“Process2” tab, for them to be compared to the files in the other pane
of the latter tab (two sets of files will be needed for this
comparison).

<img src="./media/image5.png"
style="width:2.69792in;height:3.96935in" />

Dropping files adds them to the files already existing in the given
pane. The number of total files eligible for processing in each pane
(denoted as \# above) should appear inside the square brackets.

-   Press the “RUN” button
    <img src="./media/image4.png" style="width:0.31in;height:0.28in" />
    near the lower left corner of the Brainstorm toolbox window to bring
    the “Pipeline editor”.

<img src="./media/image6.png"
style="width:3.89638in;height:1.54188in" />

-   Press the “Add process” button
    <img src="./media/image6.png" style="width:0.32292in;height:0.3125in" />
    to bring the drop-down list of available processes.

<img src="./media/image7.png"
style="width:2.66926in;height:3.97917in" />

-   From “Temporal Segmentation” choose “Source-Informed Segmentation”
    to bring the “Process options” window. Maximize the window if the
    “Cancel” and “Run” buttons do not appear in the lower right corner.

<img src="./media/image8.png"
style="width:6.49935in;height:3.45903in" />

-   Enter the values and/or make the choices relevant to the intended
    *Source-Informed Segmentation* process. Note that the window will
    remember the last values and choices. To reset these to their
    corresponding defaults, in the “Pipeline editor” window press the
    “Load/save processing pipeline” button
    <img src="./media/image6.png" style="width:0.38in;height:0.26in" />,
    then from the drop-down list choose “Reset options”.

-   After entering/making all the relevant values/choices, press the
    “Run” button to start the *Source-Informed Segmentation* process.

1.  **Plugin Parameters and Options:**

    1.  <u>Window Parameters</u>

These parameters define the widths of the corresponding windows (see
section 5) used by the *Source-Informed Segmentation Algorithm* \[1\].
They are passed in either \[sample\] or \[ms\] units, or, in the case of
some of them, in the same unit used to pass some other window’s width.
The radio button below the input field of each window parameter
specifies its unit.

-   Initial Reference Window (*W*<sub>*r*</sub>): the initial width of
    the reference window, where *W*<sub>*r*</sub> &gt; 0.

-   Decision Window (*W*<sub>*d*</sub>): the minimum number of
    consecutive possible boundaries needed for one of them to be
    considered a detected boundary, where *W*<sub>*d*</sub> &gt; 0.

-   Sliding Window (*W*<sub>*s*</sub>): the width of the sliding window,
    where *W*<sub>*s*</sub> &gt; 0.

-   Step (*W*<sub>*p*</sub>): the amount of each discrete expansion in
    the width of the reference window and the corresponding shift in the
    position of the sliding window, where *W*<sub>*p*</sub> &gt; 0.

-   Overlap (*W*<sub>*v*</sub>): the width of the overlap between the
    reference and the sliding window, where
    0 ≤ *W*<sub>*v*</sub> &lt; *m**i**n*(*W*<sub>*r*</sub>, *W*<sub>*s*</sub>).

    1.  <u>Time Interval to Segment</u>

Using these options, the interval to be cropped out of the EEG files
towards processing can be defined, if cropping is needed. If one or both
interval limits are undefined, the corresponding limits are assigned the
beginning or the end of the individual EEG files.

-   Start Time (*T*<sub>*s**t**a**r**t*</sub>): the starting point, in
    \[s\], of the cropping interval.

-   End Time (*T*<sub>*e**n**d*</sub>): the ending point, in \[s\], of
    the cropping interval.

-   On Encountering File(s) Incompatible with Time Interval to Segment:
    this option defines the action to take when one or more EEG files
    have time intervals that do not cover one or both limits of the
    cropping interval. The radio button can assume one of the following
    values:

    -   Ignore Incompatibility: proceed with the part of the cropping
        interval that is covered by each EEG file.

    -   Restrict Interval for Global Compatibility: redefine the
        cropping interval as the intersection of the intervals of all
        EEG files and the cropping interval to ensure compatibility
        across all files, if possible.

    -   Skip Incompatible File(s): do not process incompatible files.

    -   Abort: if any incompatible file is encountered, abort without
        processing any file, regardless of their possible compatibility.

    1.  <u>Preprocessing</u>

These options allow for various processes to be applied to the EEG data
prior to attempting to detect segment boundaries.

-   Domain of Analysis: select the domain within which the
    *Source-Informed Segmentation Algorithm* \[1\] is to be applied.
    These domains are:

    -   Time: with a functional connectivity measure equivalent to
        correlation.

    -   Frequency: with a functional connectivity measure equivalent to
        the imaginary component of coherence, using an analytical Morlet
        wavelet-based filter-bank.

    -   Phase: with a functional connectivity measure equivalent to
        phase-locking value (PLV), in terms of the analytical signal
        calculated using Hilbert transform.

-   Frequency Band of Interest
    (\[*f*<sub>*l**o**w*</sub>, *f*<sub>*h**i**g**h*</sub>\]): if
    specified, define the low and high limits in \[Hz\] of the band-pass
    filter applied to the EEG data prior to segmentation, with
    0 ≤ *f*<sub>*l**o**w*</sub> &lt; *f*<sub>*h**i**g**h*</sub>. When
    *f*<sub>*l**o**w*</sub> = 0 or
    *f*<sub>*h**i**g**h*</sub> ≥ *f*<sub>*s*</sub>/2, where
    *f*<sub>*s*</sub> is the sampling rate, a high-pass or low-pass
    filter, respectively, is applied, instead.

-   Reference Space Average Removal: whether to remove the channel-wise
    average of the reference window before calculating the reference
    space (in the time domain) or not.

    1.  <u>Segment Events</u>

These options apply to the segment boundary events to be added to the
individual EEG files to be processed.

-   Segment Events Color (\[*R*, *G*, *B*\]): the color of the added
    segment boundary events in RGB format, where 0 ≤ *R*, *G*, *B* ≤ 1.

-   Clear Pre-Existing Events: whether to clear the events already saved
    in the individual EEG files to be processed or not.

    1.  <u>Segmentation Statistics</u>

These options apply to the statistics collected from the processed EEG
files.

-   Time Bins to Count Segment Boundary/Midpoint Recurrences: if
    specified as a vector or a scalar, it is used to define the edges or
    the number, respectively, of the time bins within which the average
    numbers of segment boundaries/midpoints are counted.

-   Export Segmentation Statistics to File: if specified, a (.mat) file
    with the statistics collected from the processed EEG files is
    created and saved.

1.  **About the Source-Informed Segmentation Algorithm:**

The *Source-Informed Segmentation Algorithm* \[1\] detects the instants,
in the EEG data, at which the functional state of the brain changes. To
achieve that, the algorithm compares the EEG activity within two
windows: the *reference window*, initially of width *W*<sub>*r*</sub>,
and the *sliding window*, of constant width *W*<sub>*s*</sub>. The two
windows have an *overlap* of constant width *W*<sub>*v*</sub>. Each
comparison may reveal either a *possible boundary* or *not a boundary*.

*W*<sub>*r*</sub>

previous detected boundary

*W*<sub>*s*</sub>

?

**1** (possible boundary)

**0** (not a boundary)

*W*<sub>*v*</sub>

As consecutive comparisons are made, the reference window grows in a
*step* of constant width *W*<sub>*p*</sub>, each time, pushing the
sliding window by the same step to keep the overlap constant. A boundary
is detected when at least *W*<sub>*d*</sub>, the width of the *decision
window*, consecutive possible boundaries are found. The *detected
boundary* corresponds to the possible boundary with the maximum
likelihood, as determined by the comparison.

**1**

**0**

**1**

**1**

**1**

*W*<sub>*d*</sub>

**1**

*W*<sub>*p*</sub>

1.  **The Contents of the (.SISegment) Field of Processed EEG Files:**

This field saves the following parameters and secondary outcomes of the
*Source-Informed Segmentation Algorithm* \[1\] and other options used by
the plugin when applied to an EEG file:

-   *W*<sub>*r*</sub>: the width of the initial reference window.

-   *W*<sub>*d*</sub>: the width of the decision window.

-   *W*<sub>*s*</sub>: the width of the sliding window.

-   *W*<sub>*p*</sub>: the step width.

-   *W*<sub>*v*</sub>: the width of the overlap between the reference
    and sliding windows.

-   unit: the unit of the window parameters.

-   Domain: the domain of *Source-Informed Segmentation*.

-   Band: the frequency band of interest
    (\[*f*<sub>*l**o**w*</sub>, *f*<sub>*h**i**g**h*</sub>\]), if
    specified.

-   AvRemove: the reference space average removal option.

-   svals: (1 × no. segments) cell array with vectors carrying the set
    of significant singular values corresponding to each detected
    segment.

-   svecs: (1 × no. segments) cell array with matrices carrying the set
    of significant left singular column vectors corresponding to each
    detected segment.

-   erat: (1 × no. segments) vector with the ratios of energy captured
    by the sets of significant singular values corresponding to each
    detected segment.

-   pval: (1 × no. segments) vector with the *p*-vaues calculated at the
    detected segment boundaries, based on the Kolmogorov-Smirnov (K-S)
    test.

-   avsegs: (no. of EEG channels × no. segments) matrix with the average
    EEG topography of each detected segment.

-   stdsegs: (no. of EEG channels × no. segments) matrix with the
    channel-wise standard deviation of the EEG signal within each
    detected segment.

-   label: the label of the corresponding segment boundary events.

1.  **A Tutorial Example:**

Here, two sets of files, placed in “Files A: Data \[#\]” and “Files B:
Data \[#\]” panes of the “Process2” tab, are processed, separately,
using the *Source-Informed Segmentation* plugin.

<img src="./media/image11.png" style="width:2.71in;height:4.03in" />

The window parameters used with the *Source-Informed Segmentation
Algorithm* \[1\] are:

-   *W*<sub>*r*</sub> = 20 \[sample\], *W*<sub>*d*</sub> = 20
    \[sample\], *W*<sub>*s*</sub> = 20 \[same as *W*<sub>*r*</sub>\],
    *W*<sub>*p*</sub> = 1 \[sample\], and *W*<sub>*v*</sub> = 0
    \[sample\].

To process the interval 0 – 2 s from each EEG file, or whatever
sub-interval of it a file covers, the following options are used with
the plugin:

-   *T*<sub>*s**t**a**r**t*</sub> = 0, *T*<sub>*e**n**d*</sub> = 2, and
    “Ignore Incompatibility”.

Furthermore, EEG data is to be processed in the “Time” domain, within
the *δ*, *θ*, and *α* bands. Thus, the Frequency Band of Interest is
chosen as:

-   \[*f*<sub>*l**o**w*</sub>, *f*<sub>*h**i**g**h*</sub>\] = \[1, 16\].

For statistical summarization, segment boundaries/midpoints are counted
within the:

-   Time Bins: 0 : 0.1 : 2.

The statistics are then saved to a (.mat) file that is created and named
using the browse button
<img src="./media/image12.png" style="width:0.42in;height:0.23in" />.

<img src="./media/image12.png" style="width:6.5in;height:3.46181in" />

After processing the EEG files in both panes, separately, the processed
files appear in the “Functional data” pane, with their original names
appended by “ | SIS”.

<img src="./media/image13.png" style="width:2.71in;height:4.04in" />

Note that the segment boundary events of a given processed EEG file can
be viewed using Brainstorm’s own viewer, invoked by double-clicking the
file, and own event display formats. Below, the segment boundary events
are shown as labeled “Dots” in blue (\[*R*, *G*, *B*\] = \[0, 0, 1\]),
the color the plugin options dictated earlier. Brainstorm offers
different EEG and event viewing modes that can be controlled through the
list accessible by clicking the “Display Configuration” button
<img src="./media/image14.png" style="width:0.23in;height:0.23in" />
near the lower right corner of the viewer window.

<img src="./media/image14.png" style="width:6.5in;height:3.09722in" />

The plugin also summarizes the statistics collected from the
*Source-Informed Segmented* EEG files in each of the two sets “Files A”
and “Files B”, using 8 plots that are grouped into two figure windows.
In the case of “Process2”, each plot is used to compare the files in the
two sets. In the non-comparative case of “Process1”, each plot
corresponds to the entire set of EEG files that would be placed in the
“Files to process: Data \[#\]” pane. The statistics used in the
aforementioned plots can also be exported to the file that was specified
by the corresponding plugin option. The files saved in the cases of
“Process1” and “Process2” are the same, in terms of the structures they
contain. The main difference constitutes in the fields of these
structures that are intended for the main data entries, which, in the
case of “Process2” consist of two sub-fields themselves: (.A) and (.B)
for the corresponding file panels. Some structures also include
additional test results, *e.g.*, *p*-values and Peasrson correlation
coefficients, which give context-relevant comparisons between “Files A”
and “Files B”, in the case of “Process2”.

The first figure window includes:

-   Average No. of Segment Boundaries: the average number of segment
    boundaries, per EEG file (trial), occurring during each of the time
    bins. These bins are controlled by the corresponding plugin option
    entered earlier. The data in this plot is saved to the structure
    “HistSegmentBoundaries”.

-   Segment Length vs. Beginning Boundary: a scatter plot of all segment
    lengths vs. their corresponding beginning boundaries, across all EEG
    files. The data in this plot can be calculated from the contents
    saved in the structure “SegmentBoundaries”. In the case of
    “Process2”, a bivariate K-S test is conducted to compare “Files A”
    to “Files B” in terms of segment length/boundary pairs. The
    *p*-value of the test is shown in the plot, and is saved to the
    field “HistSegmentBoundaries.BiKSpvalue”.

-   Average No. of Segment Midpoints: the average number of segment
    midpoints, per EEG file (trial), occurring during each of the time
    bins. These bins are controlled by the corresponding plugin option
    entered earlier. The data in this plot is saved to the structure
    “HistSegmentMidPoints”.

-   Segment Length vs. Midpoint: a scatter plot of all segment lengths
    vs. their corresponding midpoints, across all EEG files. In the case
    of “Process2”, a bivariate K-S test is conducted to compare “Files
    A” to “Files B” in terms of segment length/midpoint pairs. The
    *p*-value of the test is shown in the plot, and is saved to the
    field “HistSegmentMidPoints.BiKSpvalue”.

<img src="./media/image15.png" style="width:6.5in;height:3.40903in" />

The second figure window includes:

-   Average Length of Encompassing Segment: the average length of the
    segment, across all EEG files (trials), which contain a given time
    sample, calculated dynamically at each time sample. Also plotted,
    here, is one corresponding dynamically calculated standard deviation
    above and below the average curve. The overall mean (*µ*) and
    standard deviation (*σ*) of each curve is shown in the plot. In the
    case of “Process2”, Pearson correlation coefficient of the two
    curves is calculated and shown in the plot. The data in this plot is
    saved to the structure “DynamicSegmentLength”. Similarly, the
    dynamic average/standard deviation of the duration until the end of
    the encompassing segment, at a given time sample, is calculated and
    saved to the structure “DynamicDurationtoSegEnd”, without being
    plotted.

-   PMF of Segment Lengths: the histogram, *i.e.*, empirically estimated
    probability mass function (PMF), of all segment lengths throughout
    all EEG files (trials). The average (Av) and standard deviation (SD)
    of all segment lengths are shown in the plot. The histogram is also
    fitted to a Burr distribution with parameters *c*, *k*, and *α*, all
    shown in the plot. The goodness of fit is evaluated through a
    *χ*<sup>2</sup> test and the *p*-value of it is shown in the plot.
    The histogram, the probability density function (PDF) of the
    approximate Burr distribution, and the outcomes of the
    *χ*<sup>2</sup> test are saved to the structure
    “HistSegmentLengths”. In the case of “Process2”, a K-S test is
    conducted to compare “Files A” to “Files B” in terms of the segment
    lengths. The *p*-value of this test is shown in the plot. The
    segment lengths used in this plot and the *p*-value of the K-S test
    are saved to the structure “AllSegmentLengths”.

-   Maximum Segment Length vs. Beginning Boundary: a scatter plot of the
    maximum length of the segments in each EEG file (trial) vs. their
    corresponding beginning boundaries. The average (Av) and standard
    deviation (SD) of the maximum lengths, across all EEG files, are
    shown in the plot. The data in this plot is saved to the structure
    “MaxSegmentLengths”.

-   Minimum Segment Length vs. Beginning Boundary: a scatter plot of the
    minimum length of the segments in each EEG file (trial) vs. their
    corresponding beginning boundaries. The average (Av) and standard
    deviation (SD) of the minimum lengths, across all EEG files, are
    shown in the plot. The data in this plot is saved to the structure
    “MinSegmentLengths”.

<img src="./media/image16.png" style="width:6.5in;height:3.48125in" />

**References:**

1.  [Ali E. Haddad and Laleh Najafizadeh, "Source-informed segmentation:
    A data-driven approach for the temporal segmentation of EEG," *IEEE
    Transactions on Biomedical Engineering*, vol. 66, no. 5, pp.
    1429-1446,
    2019.](https://ieeexplore.ieee.org/abstract/document/8481379)

2.  <https://neuroimage.usc.edu/brainstorm/Introduction>
