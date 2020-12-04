function varargout = process_SISegmentationMD(varargin) %#ok<STOUT>
% process_SISegmentationMD applies the source-informed segmentation algorithm [Ref]
% to the input EEG data in the time, frequency, or phase domain.

% @================================================================================
% The source-informed segmentation algorithm [Ref]:
%
%   The algorithm estimates the time intervals during which the EEG data correspond
% to stationary spatial distributions for the underlying active functional networks
% in the brain.
%
% [Ref] Ali E. Haddad and Laleh Najafizadeh, "Source-informed segmentation: A data-
%       driven approach for the temporal segmentation of EEG," IEEE Transactions on
%       Biomedical Engineering, vol. 66, no. 5, pp. 1429-1446, 2019.
%       https://ieeexplore.ieee.org/abstract/document/8481379
% ================================================================================@
%
% Author: Ali Haddad, September 2020.

eval(macro_method);
end


%% ===== GET DESCRIPTION =====
function sProcess = GetDescription() %#ok<DEFNU>
    % Description of the process
    sProcess.SubGroup    = 'Temporal Segmentation';
    sProcess.Comment     = 'Source-Informed Segmentation';
    sProcess.Category    = 'Custom';
    sProcess.Index       = 411;
    sProcess.Description = 'https://ieeexplore.ieee.org/abstract/document/8481379';
    sProcess.isSeparator = 0;
    % Definition of the input accepted by this process
    sProcess.InputTypes  = {'data'};
    sProcess.OutputTypes = {'data'};
    sProcess.nInputs     = 1;
    sProcess.nMinFiles   = 1;
    sProcess.processDim  = [];
    % Definition of the options
    % === Window Parameters
    sProcess.options.labelWin.Class     = 'Window';
    sProcess.options.labelWin.Comment   = '<U><B>Window Parameters</B></U>';
    sProcess.options.labelWin.Type      = 'label';
    % === Wr
    sProcess.options.Wr.Class           = 'Window';
    sProcess.options.Wr.Comment         = '<i>W<sub>r</sub></i>: Initial Reference Window (no default, suggested = 20 [sample]): ';
    sProcess.options.Wr.Type            = 'text';
    sProcess.options.Wr.Value           = '20';
    %
    sProcess.options.WrUnit.Class       = 'Window';
    sProcess.options.WrUnit.Comment     = {'[sample]','[ms]','<i>W<sub>r</sub></i> Unit: ';'sample','ms',''};
    sProcess.options.WrUnit.Type        = 'radio_linelabel';
    sProcess.options.WrUnit.Value       = 'sample';
    % === Wd
    sProcess.options.Wd.Class           = 'Window';
    sProcess.options.Wd.Comment         = '<i>W<sub>d</sub></i>: Decision Window (no default, suggested = 20 [sample]): ';
    sProcess.options.Wd.Type            = 'text';
    sProcess.options.Wd.Value           = '20';
    %
    sProcess.options.WdUnit.Class       = 'Window';
    sProcess.options.WdUnit.Comment     = {'[sample]','[ms]','<i>W<sub>d</sub></i> Unit: ';'sample','ms',''};
    sProcess.options.WdUnit.Type        = 'radio_linelabel';
    sProcess.options.WdUnit.Value       = 'sample';
    % === Ws
    sProcess.options.Ws.Class           = 'Window';
    sProcess.options.Ws.Comment         = '<i>W<sub>s</sub></i>: Sliding Window (default = <i>W<sub>r</sub></i> [same as <i>W<sub>r</sub></i>]): ';
    sProcess.options.Ws.Type            = 'text';
    sProcess.options.Ws.Value           = 'Wr';
    %
    sProcess.options.WsUnit.Class       = 'Window';
    sProcess.options.WsUnit.Comment     = {'[sample]', '[ms]', '[same as <i>W<sub>r</sub></i>]', '<i>W<sub>s</sub></i> Unit: '; 'sample', 'ms', 'same', ''};
    sProcess.options.WsUnit.Type        = 'radio_linelabel';
    sProcess.options.WsUnit.Value       = 'same';
    % === Wp
    sProcess.options.Wp.Class           = 'Window';
    sProcess.options.Wp.Comment         = '<i>W<sub>p</sub></i>: Step (default = 1 [sample]): ';
    sProcess.options.Wp.Type            = 'text';
    sProcess.options.Wp.Value           = '1';
    %
    sProcess.options.WpUnit.Class       = 'Window';
    sProcess.options.WpUnit.Comment     = {'[sample]', '[ms]', '[same as <i>W<sub>s</sub></i>]', '<i>W<sub>p</sub></i> Unit: '; 'sample', 'ms', 'same', ''};
    sProcess.options.WpUnit.Type        = 'radio_linelabel';
    sProcess.options.WpUnit.Value       = 'sample';
    % === Wv
    sProcess.options.Wv.Class           = 'Window';
    sProcess.options.Wv.Comment         = '<i>W<sub>v</sub></i>: Overlap (<i>W<sub>v</sub></i> &lt min(<i>W<sub>r</sub></i>,<i>W<sub>s</sub></i>), default = 0 [sample]): ';
    sProcess.options.Wv.Type            = 'text';
    sProcess.options.Wv.Value           = '0';
    %
    sProcess.options.WvUnit.Class       = 'Window';
    sProcess.options.WvUnit.Comment     = {'[sample]', '[ms]', '[same as <i>W<sub>s</sub></i>]', '<i>W<sub>v</sub></i> Unit: '; 'sample', 'ms', 'same', ''};
    sProcess.options.WvUnit.Type        = 'radio_linelabel';
    sProcess.options.WvUnit.Value       = 'sample';
    % === Time Interval to Segment
    sProcess.options.labelIntrv.Class   = 'Interval';
    sProcess.options.labelIntrv.Comment = '<U><B>Time Interval to Segment</B></U>';
    sProcess.options.labelIntrv.Type    = 'label';
    % === Tstart
    sProcess.options.Tstart.Class       = 'Interval';
    sProcess.options.Tstart.Comment     = '<i>T<sub>start</sub></i>: Start Time [s] (leave blank for default = from the start of each file): ';
    sProcess.options.Tstart.Type        = 'text';
    sProcess.options.Tstart.Value       = '';
    % === Tend
    sProcess.options.Tend.Class         = 'Interval';
    sProcess.options.Tend.Comment       = '<i>T<sub>end</sub></i>: End Time [s] (leave blank for default = until the end of each file): ';
    sProcess.options.Tend.Type          = 'text';
    sProcess.options.Tend.Value         = '';
    % === TIncompat
    sProcess.options.TIncompat.Class    = 'Interval';
    sProcess.options.TIncompat.Comment  = {'Ignore Incompatibility', 'Restrict Interval for Global Compatibility', 'Skip Incompatible File(s)', 'Abort', 'On Encountering File(s) Incompatible with Time Interval to Segment: '; 'ignore', 'restrict', 'skip', 'abort', ''};
    sProcess.options.TIncompat.Type     = 'radio_linelabel';
    sProcess.options.TIncompat.Value    = 'ignore';
    % === Preprocessing
    sProcess.options.labelPre.Class     = 'Pre';
    sProcess.options.labelPre.Comment   = '<U><B>Preprocessing</B></U>';
    sProcess.options.labelPre.Type      = 'label';
    % === Domain
    sProcess.options.Domain.Class       = 'Pre';
    sProcess.options.Domain.Comment     = {'Time', 'Frequency (<i>Imaginary Component of Wavelet Cross-Spectrum</i>, *slow*)', 'Phase (<i>Hilbert Transform-Based Analytic Signal</i>)', 'Domain of Analysis: '; 'time', 'frequency', 'phase', ''};
    sProcess.options.Domain.Type        = 'radio_linelabel';
    sProcess.options.Domain.Value       = 'time';
    % === Band
    sProcess.options.Band.Class         = 'Pre';
    sProcess.options.Band.Comment       = '[<i>f<sub>low</sub></i>, <i>f<sub>high</sub></i>]: Frequency Band of Interest [Hz] (0 &le <i>f<sub>low</sub></i> &lt <i>f<sub>high</sub></i>, leave blank for default = <i>Entire Band</i> for Time and Phase Domains, or default = [1, 50] for Frequency Domain): ';
    sProcess.options.Band.Type          = 'text';
    sProcess.options.Band.Value         = '';
    % === AvRemove
    sProcess.options.AvRemove.Class     = 'Pre';
    sProcess.options.AvRemove.Comment   = {'Yes', 'No', 'Reference Space Average Removal (Time Domain only): '; 'yes', 'no', ''};
    sProcess.options.AvRemove.Type      = 'radio_linelabel';
    sProcess.options.AvRemove.Value     = 'no';
    % === VoicesPOct
    sProcess.options.VoicesPOct.Class   = 'Pre';
    sProcess.options.VoicesPOct.Comment = 'Voices per Octave (Frequency Domain only, even number between 4 and 48, default = 4 *higher is slower*): ';
    sProcess.options.VoicesPOct.Type    = 'text';
    sProcess.options.VoicesPOct.Value   = '4';
    sProcess.options.VoicesPOct.Hidden  = 1;
    % === Segment Events
    sProcess.options.Eventlabel.Class   = 'Event';
    sProcess.options.Eventlabel.Comment = '<U><B>Segment Events</B></U>';
    sProcess.options.Eventlabel.Type    = 'label';
    % === Color
    sProcess.options.Color.Class        = 'Event';
    sProcess.options.Color.Comment      = '[<i>R</i>, <i>G</i>, <i>B</i>]: Segment Events Color  (0 &le <i>R</i>, <i>G</i>, <i>B</i> &le 1, default is <i>Blue</i> = [0, 0, 1]): ';
    sProcess.options.Color.Type         = 'text';
    sProcess.options.Color.Value        = '[0, 0, 1]';
    % === ClrPreEvts
    sProcess.options.ClrPreEvts.Class   = 'Event';
    sProcess.options.ClrPreEvts.Comment = {'Yes', 'No', 'Clear Pre-Existing Events: '; 'yes', 'no', ''};
    sProcess.options.ClrPreEvts.Type    = 'radio_linelabel';
    sProcess.options.ClrPreEvts.Value   = 'yes';
    % === seglabel
    sProcess.options.seglabel.Class     = 'Event';
    sProcess.options.seglabel.Comment   = {'Segment Boundary Label: '};
    sProcess.options.seglabel.Type      = 'text';
    sProcess.options.seglabel.Value     = 'SISGMNT';
    sProcess.options.seglabel.Hidden    = 1;
    % === segFileTag
    sProcess.options.segFileTag.Class   = 'Event';
    sProcess.options.segFileTag.Comment = {'Comment Tag Added to Segmented File(s): '};
    sProcess.options.segFileTag.Type    = 'text';
    sProcess.options.segFileTag.Value   = ' | SIS';
    sProcess.options.segFileTag.Hidden  = 1;
    % === Statslabel
    sProcess.options.Statslabel.Class   = 'Stats';
    sProcess.options.Statslabel.Comment = '<U><B>Segmentation Statistics</B></U>';
    sProcess.options.Statslabel.Type    = 'label';
    sProcess.options.Statslabel.Hidden  = 0;
    % === StatBins
    sProcess.options.StatBins.Class     = 'Stats';
    sProcess.options.StatBins.Comment   = 'Time Bins to Count Segment Boundary/Midpoint Recurrences (a vector for bin edges in [s], or a scalar integer for no. of bins, leave blank for default = <i>Auto Detect Bins</i>): ';
    sProcess.options.StatBins.Type      = 'text';
    sProcess.options.StatBins.Value     = '';
    sProcess.options.StatBins.Hidden    = 0;
    % === StatFile
    SelectOptions                       = {'', ...                                           % Filename
                                           '', ...                                           % FileFormat
                                           'save', ...                                       % Dialog type: {open,save}
                                           'Export Segmentation Statistics to File ...', ... % Window title
                                           '', ...                                           % LastUsedDir: {ImportData,ImportChannel,ImportAnat,ExportChannel,ExportData,ExportAnat,ExportProtocol,ExportImage,ExportScript}
                                           'single', ...                                     % Selection mode: {single,multiple}
                                           'files', ...                                      % Selection mode: {files,dirs,files_and_dirs}
                                           {'.mat', 'MATLAB data file (*.mat)', 'MAT'}, ...  % Get all the available file formats
                                           ''};                                              % DefaultFormats: {ChannelIn,DataIn,DipolesIn,EventsIn,MriIn,NoiseCovIn,ResultsIn,SspIn,SurfaceIn,TimefreqIn
    sProcess.options.StatFile.Class     = 'Stats';
    sProcess.options.StatFile.Comment   = 'Export Segmentation Statistics to File: ';
    sProcess.options.StatFile.Type      = 'filename';
    sProcess.options.StatFile.Value     = SelectOptions;
    % === AvNxtBound
    sProcess.options.AvNxtBound.Class   = 'Stats';
    sProcess.options.AvNxtBound.Comment = {'Yes', 'No', 'Show Average duration to Encompassing Segment End: '; 'yes', 'no', ''};
    sProcess.options.AvNxtBound.Type    = 'radio_linelabel';
    sProcess.options.AvNxtBound.Value   = 'no';
    sProcess.options.AvNxtBound.Hidden  = 1;
    % === Note
    sProcess.options.Note.Class         = 'Note';
    sProcess.options.Note.Comment       = '<U><B>Note:</B></U> Window and interval parameters can be passed as expressions that may include previously defined parameters, in the sequence of their appearance above, using the unsubscripted notation (Wr, Wd, Ws, Wp, Wv, Tstart, Tend).<br><i>Examples</i>: 20*1000/512, Ws-1, ceil(Wr/2), Tstart+2. All window parameters in [ms] units, except <i>W<sub>v</sub></i>, are rounded to the higher integer [sample] value, depending on the sampling rate of each file. <i>W<sub>v</sub></i> is rounded to the lower integer [sample] value.';
    sProcess.options.Note.Type          = 'label';
    % === Author
    % sProcess.options.Author.Class       = 'Author';
    % sProcess.options.Author.Comment     = '<B>Ali Haddad, 2020.</B> <i>For questions e-mail</i>: <a href="mailto:ali.haddad@rutgers.edu">ali.haddad@rutgers.edu</a>';
    % sProcess.options.Author.Type        = 'label';
end


%% ===== FORMAT COMMENT =====
function Comment = FormatComment(sProcess) %#ok<INUSD,DEFNU>
    Comment = 'Source-Informed Segmentation: estimates the intervals during which the dynamic functional networks in the brain retain the stationarity of their connectivity.  (Ali Haddad, Sept. 2020, email:ali.haddad@rutgers.edu; for citation see Online tutorial)';
end


%% ===== RUN =====
function OutputFiles = Run(sProcess, sInputs) %#ok<DEFNU>
    bst_progress('text', 'Initializing...');
    % Get option values
    WrUnit             = sProcess.options.WrUnit.Value;
    if isempty(sProcess.options.Wr.Value) || prod(isspace(sProcess.options.Wr.Value))
        bst_report('Error', 'process_SISegmentationMD', '', 'Initial Reference Window (Wr) undefined!');
        return
    else
        Wr             = eval(sProcess.options.Wr.Value);
        if ~isnumeric(Wr) || ~isscalar(Wr) || (Wr<=0)
            bst_report('Error', 'process_SISegmentationMD', '', 'Initial Reference Window (Wr) needs to be a scalar higher than 0!');
            return
        elseif strcmp(WrUnit,'sample') && (round(Wr)~=Wr)
            bst_report('Error', 'process_SISegmentationMD', '', 'Initial Reference Window (Wr) is passed as non-integer [sample]!');
            return
        end
    end
    WdUnit             = sProcess.options.WdUnit.Value;
    if isempty(sProcess.options.Wd.Value) || prod(isspace(sProcess.options.Wd.Value))
        bst_report('Error', 'process_SISegmentationMD', '', 'Decision Window (Wd) undefined!');
        return
    else
        Wd             = eval(sProcess.options.Wd.Value);
        if ~isnumeric(Wd) || ~isscalar(Wd) || (Wd<=0)
            bst_report('Error', 'process_SISegmentationMD', '', 'Decision Window (Wd) needs to be a scalar higher than 0!');
            return
        elseif strcmp(WdUnit,'sample') && (round(Wd)~=Wd)
            bst_report('Error', 'process_SISegmentationMD', '', 'Decision Window (Wd) is passed as non-integer [sample]!');
            return
        end
    end
    if isempty(sProcess.options.Ws.Value) || prod(isspace(sProcess.options.Ws.Value))
        WsUnit         = WrUnit;
        Ws             = Wr;
        bst_report('Warning', 'process_SISegmentationMD', '', 'Sliding Window (Ws) is set to default value.');
    else
        if strcmp(sProcess.options.WsUnit.Value, 'same')
            WsUnit     = WrUnit;
        else
            WsUnit     = sProcess.options.WsUnit.Value;
        end
        Ws             = eval(sProcess.options.Ws.Value);
        if ~isnumeric(Ws) || ~isscalar(Ws) || (Ws<=0)
            bst_report('Error', 'process_SISegmentationMD', '', 'Sliding Window (Ws) needs to be a scalar higher than 0!');
            return
        elseif strcmp(WsUnit,'sample') && (round(Ws)~=Ws)
            bst_report('Error', 'process_SISegmentationMD', '', 'Sliding Window (Ws) is passed as non-integer [sample]!');
            return
        end
    end
    if isempty(sProcess.options.Wp.Value) || prod(isspace(sProcess.options.Wp.Value))
        WpUnit         = 'sample';
        Wp             = 1;
        bst_report('Warning', 'process_SISegmentationMD', '', 'Step (Wp) is set to default value.');
    else
        if strcmp(sProcess.options.WpUnit.Value, 'same')
            WpUnit     = WsUnit;
        else
            WpUnit     = sProcess.options.WpUnit.Value;
        end
        Wp             = eval(sProcess.options.Wp.Value);
        if ~isnumeric(Wp) || ~isscalar(Wp) || (Wp<=0)
            bst_report('Error', 'process_SISegmentationMD', '', 'Step (Wp) needs to be a scalar higher than 0!');
            return
        elseif strcmp(WpUnit,'sample') && (round(Wp)~=Wp)
            bst_report('Error', 'process_SISegmentationMD', '', 'Step (Wp) is passed as non-integer [sample]!');
            return
        end
    end
    if isempty(sProcess.options.Wv.Value) || prod(isspace(sProcess.options.Wv.Value))
        WvUnit         = 'sample';
        Wv             = 0;
        bst_report('Warning', 'process_SISegmentationMD', '', 'Overlap (Wv) is set to default value.');
    else
        if strcmp(sProcess.options.WvUnit.Value, 'same')
            WvUnit     = WsUnit;
        else
            WvUnit     = sProcess.options.WvUnit.Value;
        end
        Wv             = eval(sProcess.options.Wv.Value);
        if ~isnumeric(Wv) || ~isscalar(Wv) || (Wv<0)
            bst_report('Error', 'process_SISegmentationMD', '', 'Overlap (Wv) needs to be a scalar equal to 0 or higher!');
            return
        elseif strcmp(WvUnit,'sample') && (round(Wv)~=Wv)
            bst_report('Error', 'process_SISegmentationMD', '', 'Overlap (Wv) is passed as non-integer [sample]!');
            return
        end
    end
    if isempty(sProcess.options.Tstart.Value) || prod(isspace(sProcess.options.Tstart.Value))
        Tstart         = [];
    else
        Tstart         = eval(sProcess.options.Tstart.Value);
        if ~isnumeric(Tstart) || ~isscalar(Tstart)
            bst_report('Error', 'process_SISegmentationMD', '', 'Start Time (Tstart) needs to be a scalar!');
            return
        end
    end
    if isempty(sProcess.options.Tend.Value) || prod(isspace(sProcess.options.Tend.Value))
        Tend           = [];
    else
        Tend           = eval(sProcess.options.Tend.Value);
        if ~isnumeric(Tend) || ~isscalar(Tend)
            bst_report('Error', 'process_SISegmentationMD', '', 'End Time (Tend) needs to be a scalar!');
            return
        end
    end
    Domain             = sProcess.options.Domain.Value;
    if isempty(sProcess.options.Band.Value) || prod(isspace(sProcess.options.Band.Value))
        switch Domain
            case {'time', 'phase'}
                Band   = [];
            case 'frequency'
                Band   = [1, 50];
        end
    else
        Band           = eval(sProcess.options.Band.Value);
        if strcmp(Domain,'frequency') && isnumeric(Band) && isempty(Band)
            Band       = [1, 50];
            bst_report('Warning', 'process_SISegmentationMD', '', 'Frequency Band of Interest cannnot be empty (Entire Band) for Frequency Domain Analysis. It is set to default band.');
        elseif ~isnumeric(Band) || ~isequal(size(Band),[1,2]) || (Band(1)<0) || (Band(1)>=Band(2))
            bst_report('Error', 'process_SISegmentationMD', '', 'Frequency Band of Interest is not in the correct format!');
            return
        end
    end
    if isempty(sProcess.options.VoicesPOct.Value) || prod(isspace(sProcess.options.VoicesPOct.Value))
        VoicesPOct     = 4;
        bst_report('Warning', 'process_SISegmentationMD', '', 'Voices Per Octave is set to default value.');
    else
        VoicesPOct     = eval(sProcess.options.VoicesPOct.Value);
        if ~isnumeric(VoicesPOct) || ~isscalar(VoicesPOct) || (VoicesPOct<4) || (VoicesPOct>48) || (round(VoicesPOct/2)~=(VoicesPOct/2))
            bst_report('Error', 'process_SISegmentationMD', '', 'Voices Per Octave needs to be an even scalar between 4 and 48!');
            return
        end
    end
    if isempty(sProcess.options.Color.Value) || prod(isspace(sProcess.options.Color.Value))
        Color          = [0, 0, 1];
        bst_report('Warning', 'process_SISegmentationMD', '', 'Segment Events Color is set to its default.');
    else
        Color          = eval(sProcess.options.Color.Value);
        if isnumeric(Color) && isempty(Color)
            Color      = [0, 0, 1];
            bst_report('Warning', 'process_SISegmentationMD', '', 'Segment Events Color is set to its default.');
        elseif ~isnumeric(Color) || ~isequal(size(Color),[1,3]) || sum(Color<0) || sum(Color>1)
            bst_report('Error', 'process_SISegmentationMD', '', 'Segment Events Color is not in the correct format!');
            return
        end
    end
    if isempty(sProcess.options.StatBins.Value) || prod(isspace(sProcess.options.StatBins.Value))
        StatBins       = [];
    else
        StatBins       = eval(sProcess.options.StatBins.Value);
        if ~isnumeric(StatBins) || (isscalar(StatBins)&&(round(StatBins)~=StatBins)) || (length(StatBins)~=numel(StatBins))
            bst_report('Error', 'process_SISegmentationMD', '', 'Time Bins not in a correct format!');
            return
        end
    end
    TIncompat          = sProcess.options.TIncompat.Value;
    switch sProcess.options.AvRemove.Value
        case 'yes'
            AvRemove   = true;
        case 'no'
            AvRemove   = false;
    end
    switch sProcess.options.ClrPreEvts.Value
        case 'yes'
            ClrPreEvts = true;
        case 'no'
            ClrPreEvts = false;
    end
    seglabel           = sProcess.options.seglabel.Value;
    segFileTag         = sProcess.options.segFileTag.Value;
    StatFile           = sProcess.options.StatFile.Value{1};
    switch sProcess.options.AvNxtBound.Value
        case 'yes'
            AvNxtBound = true;
        case 'no'
            AvNxtBound = false;
    end
    % Checking compatibility of input file(s) with time interval to segment
    bst_progress('text', 'Checking file compatibility...');
    nFiles           = length(sInputs);
    Tbounds          = zeros(nFiles, 2);
    srates           = zeros(nFiles, 1);
    idxFiles         = 1:nFiles;
    for i = idxFiles
        TimeVector   = in_bst(sInputs(i).FileName, 'Time');
        Tbounds(i,:) = [TimeVector(1), TimeVector(end)];
        srates(i)    = 1 / (TimeVector(2)-TimeVector(1));
    end
    if isempty(Tstart)
        Tstart       = min(Tbounds(:,1));
    end
    if isempty(Tend)
        Tend         = max(Tbounds(:,2));
    end
    if Tend <= Tstart
        bst_report('Error', 'process_SISegmentationMD', '', 'End Time (Tend) needs to be higher than Start Time (Tstart)!');
        return
    end
    incompat         = or(Tbounds(:,1)>Tstart, Tbounds(:,2)<Tend)';
    Trestrict        = [max([Tbounds(:,1);Tstart]), min([Tbounds(:,2);Tend])];
    % Handling incompatibilities with time interval to segment and inequality of sampling rates
    if sum(incompat) > 0
        switch TIncompat
            case 'ignore'
                if Trestrict(2) <= Trestrict(1)
                    bst_report('Warning', 'process_SISegmentationMD', {sInputs(incompat).FileName}, ['Ignored the incompatibility of ',num2str(sum(incompat)),' file(s) with the Time Interval to Segment. All ',num2str(nFiles),' file(s) processed. Note: no globally compatible time interval found.']);
                else
                    bst_report('Warning', 'process_SISegmentationMD', {sInputs(incompat).FileName}, ['Ignored the incompatibility of ',num2str(sum(incompat)),' file(s) with the Time Interval to Segment. All ',num2str(nFiles),' file(s) processed. Note: the strictest globally compatible time interval would have been: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s].']);
                end
                TInterval       = [Tstart, Tend];
                idxProcessFiles = idxFiles;
            case 'restrict'
                if Trestrict(2) <= Trestrict(1)
                    bst_report('Error', 'process_SISegmentationMD', {sInputs(incompat).FileName}, 'No globally compatible time interval to Segment found! No file(s) processed.');
                    return
                else
                    bst_report('Warning', 'process_SISegmentationMD', {sInputs(incompat).FileName}, ['Restricted the Time Interval to Segment to: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s] for global compatibility. All ',num2str(nFiles),' file(s) processed accordingly. Note: ',num2str(sum(incompat)),' file(s) found incompatible with the user-input interval.']);
                end
                TInterval       = Trestrict;
                idxProcessFiles = idxFiles;
            case 'skip'
                if (sum(incompat)>=nFiles) && (Trestrict(2)<=Trestrict(1))
                    bst_report('Error', 'process_SISegmentationMD', {sInputs(incompat).FileName}, ['Skipped ',num2str(sum(incompat)),' file(s) incompatible with the Time Interval to Segment. No remaining files to process! Note: no globally compatible time interval found.']);
                    return
                elseif sum(incompat) >= nFiles
                    bst_report('Error', 'process_SISegmentationMD', {sInputs(incompat).FileName}, ['Skipped ',num2str(sum(incompat)),' file(s) incompatible with the Time Interval to Segment. No remaining files to process! Note: the strictest globally compatible time interval would have been: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s].']);
                    return
                elseif Trestrict(2) <= Trestrict(1)
                    bst_report('Warning', 'process_SISegmentationMD', {sInputs(incompat).FileName}, ['Skipped ',num2str(sum(incompat)),' file(s) incompatible with the Time Interval to Segment. The remaining ',num2str(nFiles-sum(incompat)),' file(s) processed. Note: no globally compatible time interval found.']);
                else
                    bst_report('Warning', 'process_SISegmentationMD', {sInputs(incompat).FileName}, ['Skipped ',num2str(sum(incompat)),' file(s) incompatible with the Time Interval to Segment. The remaining ',num2str(nFiles-sum(incompat)),' file(s) processed. Note: the strictest globally compatible time interval would have been: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s].']);
                end
                TInterval       = [Tstart, Tend];
                idxProcessFiles = idxFiles(~incompat);
            case 'abort'
                if Trestrict(2) <= Trestrict(1)
                    bst_report('Error', 'process_SISegmentationMD', {sInputs(incompat).FileName}, ['Aborted. ',num2str(sum(incompat)),' file(s) found incompatible with the Time Interval to Segment! No file(s) processed. Note: no globally compatible time interval found.']);
                else
                    bst_report('Error', 'process_SISegmentationMD', {sInputs(incompat).FileName}, ['Aborted. ',num2str(sum(incompat)),' file(s) found incompatible with the Time Interval to Segment! No file(s) processed. Note: the strictest compatible time interval would have been: ',num2str(Trestrict(1)),' to ',num2str(Trestrict(2)),' [s].']);
                end
                return
        end
    else
        TInterval               = [Tstart, Tend];
        idxProcessFiles         = idxFiles;
    end
    if sum(srates(idxProcessFiles(1)) ~= srates(idxProcessFiles))
        bst_report('Warning', 'process_SISegmentationMD', {sInputs(idxProcessFiles).FileName}, ['Sampling rate varied between: ',num2str(min(srates(idxProcessFiles))),' and ',num2str(max(srates(idxProcessFiles))),' [sample/s] across the processed files.']);
    end 
    if ~isempty(Band) && (Band(1)>=min(srates(idxProcessFiles))/2)
        Bincompat               = Band(1) >= srates/2; % Notify about all incompatibilities
        bst_report('Error', 'process_SISegmentationMD', {sInputs(Bincompat).FileName}, [num2str(sum(Bincompat)),' file(s) incompatible with the Frequqncy Band of Interest!']);
        return
    end
    % Processing input file(s)
    bst_progress('text', 'Segmenting file(s)...');
    AllTimeVecs = cell(1, length(idxProcessFiles));
    Bounds      = cell(2, length(idxProcessFiles));
    PropBounds  = cell(1, length(idxProcessFiles));
    PropLENs    = cell(1, length(idxProcessFiles));
    MAXLENs     = zeros(2, length(idxProcessFiles));
    MINLENs     = zeros(2, length(idxProcessFiles));
    OutputFiles = cell(1, length(idxProcessFiles));
    idx         = 0;
    for i = idxProcessFiles
        idx = idx + 1;
        % ===== LOAD THE DATA =====
        % Read file #i
        DataMat                   = in_bst(sInputs(i).FileName, TInterval);
        if ~isfield(DataMat, 'SISegment') && ~ClrPreEvts
            preINFO               = in_bst_data(sInputs(i).FileName, 'SISegment');
            if ~isempty(preINFO.SISegment)
                DataMat.SISegment = preINFO.SISegment;
            end
        elseif isfield(DataMat, 'SISegment') && ClrPreEvts
            DataMat               = rmfield(DataMat, 'SISegment');
        end
        AllTimeVecs{idx}          = DataMat.Time;
        % Convert window parameters to [sample] if necessary
        switch WrUnit
            case 'sample'
                W_r = Wr;
            case 'ms'
                W_r = ceil(Wr * srates(i) / 1000);
        end
        switch WdUnit
            case 'sample'
                W_d = Wd;
            case 'ms'
                W_d = ceil(Wd * srates(i) / 1000);
        end
        switch WsUnit
            case 'sample'
                W_s = Ws;
            case 'ms'
                W_s = ceil(Ws * srates(i) / 1000);
        end
        switch WpUnit
            case 'sample'
                W_p = Wp;
            case 'ms'
                W_p = ceil(Wp * srates(i) / 1000);
        end
        switch WvUnit
            case 'sample'
                W_v = Wv;
            case 'ms'
                W_v = floor(Wv * srates(i) / 1000);
        end
        if W_v >= min(W_r,W_s)
            bst_report('Error', 'process_SISegmentationMD', sInputs(i).FileName, 'Overlap (Wv) needs to satisfy Wv < min(Wr,Ws)!');
            return
        end
        % ===== PROCESS =====
        [SEGPNTS, INFO]       = Compute(DataMat.F, W_r, W_d, W_s, W_p, W_v, Domain, AvRemove, Band, srates(i), [idx-1,length(idxProcessFiles)], VoicesPOct);
        nsegs                 = length(SEGPNTS);
        Bounds{1, idx}        = AllTimeVecs{idx}(SEGPNTS);
        Bounds{2, idx}        = [AllTimeVecs{idx}(SEGPNTS(2:nsegs)-1), AllTimeVecs{idx}(end)];
        PropBounds{idx}       = Bounds{1, idx}(2:nsegs);
        PropLENs{idx}         = 1000 * (Bounds{2,idx}(2:nsegs)-Bounds{1,idx}(2:nsegs)); % [ms]
        [MAXLENs(2,idx), seq] = max(1000 * (Bounds{2,idx}-Bounds{1,idx}));
        MAXLENs(1,idx)        = AllTimeVecs{idx}(SEGPNTS(seq));
        [MINLENs(2,idx), seq] = min(1000 * (Bounds{2,idx}-Bounds{1,idx}));
        MINLENs(1,idx)        = AllTimeVecs{idx}(SEGPNTS(seq));
        % ===== SAVE THE RESULTS =====
        % Update data file structure
        if ~isfield(DataMat, 'Events')
            Nevt_prev     = 0;
            NSIS_prev     = 0;
        elseif ClrPreEvts
            DataMat       = rmfield(DataMat, 'Events');
            Nevt_prev     = 0;
            NSIS_prev     = 0;
        else
            Nevt_prev     = length(DataMat.Events);
            if Nevt_prev > 0
                NSIS_prev = length(cell2mat(strfind({DataMat.Events.label}, seglabel)));
            else
                NSIS_prev = 0;
            end
        end
        if NSIS_prev == 0
            labelext      = '';
        else
            labelext      = ['(', num2str(NSIS_prev+1), ')'];
        end
        Notes             = cell(1, nsegs);
        for seg = 1:nsegs
            Notes{seg}    = num2str(seg);
        end
        if isempty(Band)
            HNBs          = '[ ]';
        else
            HNBs          = ['[', num2str(Band(1)), ',', num2str(Band(2)), '] [Hz]'];
        end
        Hnotes            = ['label=',        seglabel,labelext, ', ', ...
                             'Wr=',           num2str(W_r),      ', ', ...
                             'Wd=',           num2str(W_d),      ', ', ...
                             'Ws=',           num2str(W_s),      ', ', ...
                             'Wp=',           num2str(W_p),      ', ', ...
                             'Wv=',           num2str(W_v),      ', ', ...
                             'unit=',         '[sample]',        ', ', ...
                             'Domain=',       Domain,            ', ', ...
                             '[flow,fhigh]=', HNBs,              ', ', ...
                             'AvRemove=',     num2str(AvRemove)];
        INFO.label        = [seglabel, labelext];
        if isempty(strfind(DataMat.Comment, segFileTag))
            DataMat.Comment                    = [DataMat.Comment, segFileTag];
        end
        DataMat.Events(Nevt_prev+1).label      = [seglabel, labelext];
        DataMat.Events(Nevt_prev+1).color      = Color;
        DataMat.Events(Nevt_prev+1).epochs     = ones(1,nsegs);
        DataMat.Events(Nevt_prev+1).times      = [Bounds{1, idx}; Bounds{2, idx}];
        DataMat.Events(Nevt_prev+1).reactTimes = [];
        DataMat.Events(Nevt_prev+1).select     = 1;
        DataMat.Events(Nevt_prev+1).channels   = cell(1,nsegs);
        DataMat.Events(Nevt_prev+1).notes      = Notes;
        if ~isfield(DataMat, 'History')
            DataMat.History                    = {datetime, 'Source-Informed Segmentation', Hnotes};
        else
            Nhst_prev                          = size(DataMat.History, 1);
            DataMat.History{Nhst_prev+1,1}     = datetime;
            DataMat.History{Nhst_prev+1,2}     = 'Source-Informed Segmentation';
            DataMat.History{Nhst_prev+1,3}     = Hnotes;
        end
        if ~isfield(DataMat, 'SISegment')
            DataMat.SISegment(1)               = INFO;
        else
            Ninf_prev                          = length(DataMat.SISegment);
            DataMat.SISegment(Ninf_prev+1)     = INFO;
        end
        % Create output filename
        [FilePath, FileName] = fileparts(sInputs(i).FileName);
        OutputFiles{idx}     = bst_process('GetNewFilename', FilePath, [FileName,'_SIS',labelext]);
        % Save on disk
        save(OutputFiles{idx}, '-struct', 'DataMat');
        % Get output study (pick the one from the respective original file(s))
        iStudy = sInputs(i).iStudy;
        % Register in the database
        db_add_data(iStudy, OutputFiles{idx}, DataMat);
    end
    % Segmentation statistics
    bst_progress('text', 'Generating Statistics...');
    BoundsMat         = cell2mat(Bounds);
    if isempty(StatBins)
        [HB, edgesB]  = histcounts(cell2mat(PropBounds), 'BinLimits',TInterval);
        [HM, edgesM]  = histcounts(mean(BoundsMat,1), 'BinLimits',TInterval);
    elseif isscalar(StatBins)
        [HB, edgesB]  = histcounts(cell2mat(PropBounds), StatBins, 'BinLimits',TInterval);
        [HM, edgesM]  = histcounts(mean(BoundsMat,1), StatBins, 'BinLimits',TInterval);
    else
        [HB, edgesB]  = histcounts(cell2mat(PropBounds), StatBins);
        [HM, edgesM]  = histcounts(mean(BoundsMat,1), StatBins);
    end
    if (sum(incompat)>0) && strcmp(TIncompat,'ignore')
        for i = 1:length(HB)
            if HB(i) > 0
                HB(i) = HB(i) * (edgesB(i+1)-edgesB(i)) / sum(max(min(edgesB(i+1),Tbounds(idxProcessFiles,2))-max(edgesB(i),Tbounds(idxProcessFiles,1)),0));
            end
        end
        for i = 1:length(HM)
            if HM(i) > 0
                HM(i) = HM(i) * (edgesM(i+1)-edgesM(i)) / sum(max(min(edgesM(i+1),Tbounds(idxProcessFiles,2))-max(edgesM(i),Tbounds(idxProcessFiles,1)),0));
            end
        end
    else
        HB            = HB / length(idxProcessFiles);
        HM            = HM / length(idxProcessFiles);
    end
    SEGLENS           = 1000 * diff(BoundsMat,1,1); % [ms]
    timesP            = unique(cell2mat(AllTimeVecs))';
    LENav             = zeros(size(timesP));
    LENsd             = zeros(size(timesP));
    NXTav             = zeros(size(timesP));
    NXTsd             = zeros(size(timesP));
    for i = 1:length(timesP)
        SEL           = and(timesP(i)>=BoundsMat(1,:), timesP(i)<=BoundsMat(2,:));
        LENav(i)      = mean(SEGLENS(SEL));
        LENsd(i)      = std(SEGLENS(SEL));
        NXTav(i)      = mean(1000 * (BoundsMat(2,SEL)-timesP(i)));
        NXTsd(i)      = std(1000 * (BoundsMat(2,SEL)-timesP(i)));
    end
    AVdyn             = trapz(timesP,LENav) / (TInterval(2)-TInterval(1));
    SDdyn             = (trapz(timesP,(LENav-AVdyn).^2)/(TInterval(2)-TInterval(1))) ^ 0.5;
%     NSDpos            = floor((max(LENav)-AVdyn) / SDdyn);
%     NSDneg            = floor((AVdyn-min(LENav)) / SDdyn);
    AV                = mean(SEGLENS);
    SD                = std(SEGLENS);
    AVmax             = mean(MAXLENs(2,:));
    SDmax             = std(MAXLENs(2,:));
    AVmin             = mean(MINLENs(2,:));
    SDmin             = std(MINLENs(2,:));
    % Plot statistics
    allow_ntcks        = 25; % Allowed number of histogram ticks
    figure('name', 'Segmentation Statistics')
    set(gcf, 'windowstate','maximized');
    subplot(2, 2, 1)
    histogram('BinEdges',edgesB, 'BinCounts',HB, 'FaceColor','b');
    set(gca, 'fontsize',10, 'ygrid','on', 'gridalpha',1, 'yminorgrid','on', 'minorgridalpha',1)
    if length(edgesB) <= allow_ntcks
        set(gca, 'xtick',edgesB, 'xticklabel',round(edgesB*1000)/1000, 'xticklabelrotation',90)
    else
        set(gca, 'xtick',edgesB(1:ceil(length(edgesB)/allow_ntcks):length(edgesB)), 'xticklabel',round(edgesB(1:ceil(length(edgesB)/allow_ntcks):length(edgesB))*1000)/1000, 'xticklabelrotation',90)
    end
    box on
    xlabel('time [s]', 'fontsize',12)
    ylabel('recurrence [per trial]', 'fontsize',12)
    title('Average No. of Segment Boundaries', 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 3)
    histogram('BinEdges',edgesM, 'BinCounts',HM, 'FaceColor','g');
    set(gca, 'fontsize',10, 'ygrid','on', 'gridalpha',1, 'yminorgrid','on', 'minorgridalpha',1)
    if length(edgesM) <= allow_ntcks
        set(gca, 'xtick',edgesM, 'xticklabel',round(edgesM*1000)/1000, 'xticklabelrotation',90)
    else
        set(gca, 'xtick',edgesM(1:ceil(length(edgesM)/allow_ntcks):length(edgesM)), 'xticklabel',round(edgesM(1:ceil(length(edgesM)/allow_ntcks):length(edgesM))*1000)/1000, 'xticklabelrotation',90)
    end
    box on
    xlabel('time [s]', 'fontsize',12)
    ylabel('recurrence [per trial]', 'fontsize',12)
    title('Average No. of Segment Midpoints', 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 2)
    scatter(cell2mat(PropBounds), cell2mat(PropLENs), 'b')
    set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    xlabel('time [s]', 'fontsize',12)
    ylabel('segment length [ms]', 'fontsize',12)
    title('Segment Length vs. Beginning Boundary', 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 4)
    scatter(mean(BoundsMat,1), SEGLENS, 'g')
    set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    xlabel('time [s]', 'fontsize',12)
    ylabel('segment length [ms]', 'fontsize',12)
    title('Segment Length vs. Midpoint', 'fontsize',12, 'fontweight','b')
    figure('name', 'Segmentation Statistics')
    set(gcf, 'windowstate','maximized');
    AX                 = subplot(2, 2, 1); %#ok<NASGU>
    hold on
%     yyaxis left
    fill([timesP;flipud(timesP)], [LENav-LENsd;flipud(LENav+LENsd)], [0.5,0.5,0.5], 'facealpha',0.5, 'edgecolor',[0.5,0.5,0.5], 'edgealpha',0.5)
    plot(timesP, LENav, 'k-', 'linewidth',2);
    set(gca, 'ycolor','k', 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    ylabel('segment length [ms]', 'fontsize',12)
%     yyaxis right
%     dyntcks            = [];
%     dynlbls            = {};
%     if NSDneg > 0
%         dyntcks(1)     = AVdyn - NSDneg*SDdyn;
%         dynlbls{1}     = ['\mu-', num2str(NSDneg), '\sigma = ', num2str(round(10*(AVdyn-NSDneg*SDdyn))/10)];
%         plot(timesP, AVdyn-SDdyn*ones(size(timesP))*(1:NSDneg), 'r--', 'linewidth',1.5);
%     end
%     dyntcks(end+1)     = AVdyn;
%     dynlbls{end+1}     = ['\mu = ', num2str(round(10*AVdyn)/10)];
%     plot(timesP, AVdyn*ones(size(timesP)), 'r-', 'linewidth',1.5);
%     if NSDpos > 0
%         dyntcks(end+1) = AVdyn + NSDpos*SDdyn;
%         dynlbls{end+1} = ['\mu+', num2str(NSDpos), '\sigma = ', num2str(round(10*(AVdyn+NSDpos*SDdyn))/10)];
%         plot(timesP, AVdyn+SDdyn*ones(size(timesP))*(1:NSDpos), 'r--', 'linewidth',1.5);
%     end
%     set(gca, 'ycolor','r', 'fontsize',10, 'ytick',dyntcks, 'yticklabel',dynlbls)
%     linkprop([AX.YAxis(1),AX.YAxis(2)], 'limits');
    xlabel('time [s]', 'fontsize',12)
    title(['Average Length of Encompassing Segment',' (\mu = ',num2str(round(10*AVdyn)/10),', \sigma = ',num2str(round(10*SDdyn)/10),' [ms])'], 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 3)
    HL = histogram(SEGLENS, 'FaceColor','r', 'normalization','pdf');
    set(gca, 'fontsize',10, 'ygrid','on', 'gridalpha',1, 'yminorgrid','on', 'minorgridalpha',1)
    set(gca, 'xtick',HL.BinEdges(1:ceil(length(HL.BinEdges)/allow_ntcks):length(HL.BinEdges)), 'xticklabel',round(HL.BinEdges(1:ceil(length(HL.BinEdges)/allow_ntcks):length(HL.BinEdges))), 'xticklabelrotation',90)
    try
        PDF            = fitdist(SEGLENS', 'Burr');
        [~, pval, chi] = chi2gof(SEGLENS', 'CDF',PDF, 'Edges',HL.BinEdges, 'EMin',0);
        hold on
        plot(HL.BinEdges(1):HL.BinEdges(end), pdf(PDF,HL.BinEdges(1):HL.BinEdges(end)), '-', 'color',[0.5,0,0.5], 'linewidth',2);
        legend('histogram', ['Burr distribution\newline','c = ',num2str(round(100*PDF.c)/100),', k = ',num2str(round(100*PDF.k)/100),', \alpha = ',num2str(round(100*PDF.alpha)/100),'\newline','\chi^2 test p-value = ',num2str(pval,'%1.2g')]);
    catch
        PDF            = [];
    end
    box on
    xlabel('segment length [ms]', 'fontsize',12)
    ylabel('probability', 'fontsize',12)
    title(['PMF of Segment Lengths',' (Av = ',num2str(round(10*AV)/10),', SD = ',num2str(round(10*SD)/10),' [ms])'], 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 2)
    scatter(MAXLENs(1,:), MAXLENs(2,:), 'MarkerEdgeColor',[0.5,0,0.5], 'LineWidth',2)
    set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    xlabel('time [s]', 'fontsize',12)
    ylabel('segment length [ms]', 'fontsize',12)
    title(['Maximum Segment Length vs. Beginning Boundary',' (Av = ',num2str(round(10*AVmax)/10),', SD = ',num2str(round(10*SDmax)/10),' [ms])'], 'fontsize',12, 'fontweight','b')
    subplot(2, 2, 4)
    scatter(MINLENs(1,:), MINLENs(2,:), 'MarkerEdgeColor',[0.5,0.5,0], 'LineWidth',2)
    set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
    grid on
    box on
    xlabel('time [s]', 'fontsize',12)
    ylabel('segment length [ms]', 'fontsize',12)
    title(['Minimum Segment Length vs. Beginning Boundary',' (Av = ',num2str(round(10*AVmin)/10),', SD = ',num2str(round(10*SDmin)/10),' [ms])'], 'fontsize',12, 'fontweight','b')
    if AvNxtBound
        figure('name', 'Segmentation Statistics')
        hold on
        fill([timesP;flipud(timesP)], [NXTav-NXTsd;flipud(NXTav+NXTsd)], [1,0,1], 'facealpha',0.5, 'edgecolor',[1,0,1], 'edgealpha',0.5)
        plot(timesP, NXTav, '-', 'color',[0.5,0,0.5], 'linewidth',2);
        set(gca, 'fontsize',10, 'gridalpha',1, 'xminorgrid','on', 'yminorgrid','on', 'minorgridalpha',1, 'xlim',TInterval)
        xlabel('time [s]', 'fontsize',12)
        ylabel('remaining duration [ms]', 'fontsize',12)
        title('Average duration until Encompassing Segment End', 'fontsize',12, 'fontweight','b')
        grid on
        box on
    end
    % Export statistics to file
    if ~isempty(StatFile)
        SegmentBoundaries.Begin         = Bounds(1,:);
        SegmentBoundaries.End           = Bounds(2,:);
        SegmentBoundaries.unit          = '[s]';
        HistSegmentBoundaries.BinEdges  = edgesB;
        HistSegmentBoundaries.BinCounts = HB;
        HistSegmentMidPoints.BinEdges   = edgesM;
        HistSegmentMidPoints.BinCounts  = HM;
        AllSegmentLengths.Lengths       = SEGLENS;
        AllSegmentLengths.Av            = AV;
        AllSegmentLengths.SD            = SD;
        AllSegmentLengths.unit          = '[ms]';
        MaxSegmentLengths.time          = MAXLENs(1,:);
        MaxSegmentLengths.Lengths       = MAXLENs(2,:);
        MaxSegmentLengths.Av            = AVmax;
        MaxSegmentLengths.SD            = SDmax;
        MaxSegmentLengths.unit          = '[ms]';
        MinSegmentLengths.time          = MINLENs(1,:);
        MinSegmentLengths.Lengths       = MINLENs(2,:);
        MinSegmentLengths.Av            = AVmin;
        MinSegmentLengths.SD            = SDmin;
        MinSegmentLengths.unit          = '[ms]';
        DynamicSegmentLength.time       = timesP;
        DynamicSegmentLength.DynAv      = LENav;
        DynamicSegmentLength.DynSD      = LENsd;
        DynamicSegmentLength.mu         = AVdyn;
        DynamicSegmentLength.sigma      = SDdyn;
        DynamicDurationtoSegEnd.time    = timesP;
        DynamicDurationtoSegEnd.DynAv   = NXTav;
        DynamicDurationtoSegEnd.DynSD   = NXTsd;
        HistSegmentLengths.BinEdges     = HL.BinEdges;
        HistSegmentLengths.BinCounts    = HL.Values;
        if ~isempty(PDF)
            HistSegmentLengths.PDF      = PDF;
            HistSegmentLengths.pvalue   = pval;
            HistSegmentLengths.chi2     = chi;
        end
        save(StatFile, 'SegmentBoundaries', 'HistSegmentBoundaries', 'HistSegmentMidPoints', 'AllSegmentLengths', 'MaxSegmentLengths', 'MinSegmentLengths', 'DynamicSegmentLength', 'DynamicDurationtoSegEnd', 'HistSegmentLengths')
    end
end


%% ===== COMPUTE =====
function [SEGPNTS, INFO] = Compute(EEG, Wr, Wd, Ws, Wp, Wv, Domain, AvRemove, Band, srate, prgrss_factor, VoicesPOct)
    % [SEGPNTS, INFO] = Compute(EEG, Wr, Wd, Ws, Wp, Wv, Domain, AvRemove, Band, srate, prgrss_factor, VoicesPOct)

    % Source-informed segmentation.
    % EEG     = (nchan * T) EEG matrix with nchan channels and T time samples.
    % SEGPNTS = (1 * nsegs) segment beginning boundary indeces (always starting with 1).
    % INFO    = information structure,
    %           INFO.Wr       = Wr,
    %           INFO.Wd       = Wd,
    %           INFO.Ws       = Ws,
    %           INFO.Wp       = Wp,
    %           INFO.Wv       = Wv,
    %           INFO.unit     = '[sample]',
    %           INFO.Domain   = Domain,
    %           INFO.Band     = Band,
    %           INFO.AvRemove = AvRemove,
    %           INFO.svals    = (1 * nsegs) cell array with (1 * Rseg) significant singular values,
    %           INFO.svecs    = (1 * nsegs) cell array with (nchan * Rseg) significant left singular vectors,
    %           INFO.erat     = (1 * nsegs) ratios of energy within the significant left singular space,
    %           INFO.pval     = (1 * nsegs) p-values at detected segment boundaries,
    %           INFO.avsegs   = (nchan * nsegs) average EEG segments (columns),
    %           INFO.stdsegs  = (nchan * nsegs) standard deviation of EEG segments (columns).
    
    if ~isempty(Band)
        if (Band(1)>0) && (Band(2)<srate/2)
            EEG = bandpass(EEG.', Band, srate).';
        elseif Band(1) == 0
            EEG = lowpass(EEG.', Band(2), srate).';
        elseif Band(2) >= srate/2
            EEG = highpass(EEG.', Band(1), srate).';
        end
    end
    [nchan_e, T] = size(EEG);
    switch Domain
        case 'time'
            DAT = EEG;
        case 'frequency'
            fb  = cwtfilterbank('Wavelet','amor', 'SignalLength',T, 'SamplingFrequency',srate, 'FrequencyLimits',Band, 'VoicesPerOctave',VoicesPOct);
            DAT = cell(nchan_e, 1);
            for ch = 1:nchan_e
                DAT{ch} = cwt(EEG(ch,:), 'FilterBank',fb);
            end
            DAT = cell2mat(DAT);
        case 'phase'
            DAT = hilbert(EEG.').';
    end
    nchan         = size(DAT, 1);
    INFO.Wr       = Wr;
    INFO.Wd       = Wd;
    INFO.Ws       = Ws;
    INFO.Wp       = Wp;
    INFO.Wv       = Wv;
    INFO.unit     = '[sample]';
    INFO.Domain   = Domain;
    INFO.Band     = Band;
    INFO.AvRemove = AvRemove;
    INFO.svals    = {};
    INFO.svecs    = {};
    INFO.erat     = [];
    INFO.pval     = 0;
    segind        = 1;
    SEGPNTS       = 1;
    cursegsize    = Wr;
    while (SEGPNTS(segind)+cursegsize-1+Ws-Wv) <= T
        slidpnt = SEGPNTS(segind) + cursegsize - Wv;
        refwin  = DAT(:, SEGPNTS(segind):SEGPNTS(segind)+cursegsize-1);
        slidwin = DAT(:, slidpnt:slidpnt+Ws-1);
        if AvRemove && strcmp(Domain,'time')
            refwin = refwin - mean(refwin,2);
        end
        if sum(abs(refwin(:))) == 0
            R  = 1;
            er = 1;
            Sr = 0;
            F  = ones(nchan,1) / sqrt(nchan);
        elseif strcmp(Domain, 'frequency')
            [Ur, Sr] = eigs(imag(refwin * refwin'), cursegsize);
            Sr       = sqrt(1i * imag(Sr));
            [sv, si] = sort(abs(diag(Sr)), 'descend');
            Sr       = Sr(si, si);
            Ur       = Ur(:, si);
            [R, er]  = Compute_elbow(sv(1:2:cursegsize));
            R        = 2 * R;
            F        = Ur(:, 1:R);
        else
            [Ur, Sr] = svd(refwin, 'econ');
            [R, er]  = Compute_elbow(diag(Sr));
            F        = Ur(:, 1:R);
        end
        Er           = sum(abs(refwin).^2,1) - sum(abs(F'*refwin).^2,1);
        Es           = sum(abs(slidwin).^2,1) - sum(abs(F'*slidwin).^2,1);
        [dcsn, pval] = kstest2(Er, Es);
        if dcsn
            dcsnnum     = 1;
            pv          = pval;
            slidpntminp = slidpnt;
            svals       = diag(Sr(1:R,1:R));
            svecs       = F;
            erat        = er;
            while ((pv<pval)||(dcsnnum<Wd)||(dcsnnum==1)) && dcsn
                if pv < pval
                    pval        = pv;
                    slidpntminp = slidpnt;
                    svals       = diag(Sr(1:R,1:R));
                    svecs       = F;
                    erat        = er;
                end
                cursegsize = cursegsize + Wp;
                slidpnt    = SEGPNTS(segind) + cursegsize - Wv;
                if (SEGPNTS(segind)+cursegsize-1+Ws-Wv) <= T
                    refwin  = DAT(:,SEGPNTS(segind):SEGPNTS(segind)+cursegsize-1);
                    slidwin = DAT(:,slidpnt:slidpnt+Ws-1);
                    if AvRemove && strcmp(Domain,'time')
                        refwin = refwin - mean(refwin,2);
                    end
                    if sum(abs(refwin(:))) == 0
                        R  = 1;
                        er = 1;
                        Sr = 0;
                        F  = ones(nchan,1) / sqrt(nchan);
                    elseif strcmp(Domain, 'frequency')
                        [Ur, Sr] = eigs(imag(refwin * refwin'), cursegsize);
                        Sr       = sqrt(1i * imag(Sr));
                        [sv, si] = sort(abs(diag(Sr)), 'descend');
                        Sr       = Sr(si, si);
                        Ur       = Ur(:, si);
                        [R, er]  = Compute_elbow(sv(1:2:cursegsize));
                        R        = 2 * R;
                        F        = Ur(:, 1:R);
                    else
                        [Ur, Sr] = svd(refwin, 'econ');
                        [R, er]  = Compute_elbow(diag(Sr));
                        F        = Ur(:, 1:R);
                    end
                    Er         = sum(abs(refwin).^2,1) - sum(abs(F'*refwin).^2,1);
                    Es         = sum(abs(slidwin).^2,1) - sum(abs(F'*slidwin).^2,1);
                    [dcsn, pv] = kstest2(Er, Es);
                    if dcsn
                        dcsnnum = dcsnnum + 1;
                    end
                else
                    break
                end
            end
            if dcsnnum >= Wd
                INFO.svals{segind}  = svals.';
                INFO.svecs{segind}  = svecs;
                INFO.erat(segind)   = erat;
                INFO.pval(segind+1) = pval;
                segind              = segind + 1;
                SEGPNTS(segind)     = slidpntminp; %#ok<AGROW>
                cursegsize          = Wr;
                bst_progress('set', round(100*(prgrss_factor(1)+(SEGPNTS(segind)/T))/prgrss_factor(2)));
            else
                cursegsize = cursegsize + Wp;
            end
        else
            cursegsize = cursegsize + Wp;
        end
    end
    refwin = DAT(:, SEGPNTS(segind):T);
    if AvRemove && strcmp(Domain,'time')
        refwin = refwin - mean(refwin,2);
    end
    if sum(abs(refwin(:))) == 0
        INFO.svals{segind} = 0;
        INFO.svecs{segind} = ones(nchan,1) / sqrt(nchan);
        INFO.erat(segind)  = 1;
    elseif strcmp(Domain, 'frequency')
        [Ur, Sr]           = eigs(imag(refwin * refwin'), T-SEGPNTS(segind)+1);
        Sr                 = sqrt(1i * imag(Sr));
        [sv, si]           = sort(abs(diag(Sr)), 'descend');
        Sr                 = Sr(si, si);
        Ur                 = Ur(:, si);
        [R, er]            = Compute_elbow(sv(1:2:T-SEGPNTS(segind)+1));
        R                  = 2 * R;
        INFO.svals{segind} = diag(Sr(1:R, 1:R)).';
        INFO.svecs{segind} = Ur(:, 1:R);
        INFO.erat(segind)  = er;
    else
        [Ur, Sr]           = svd(refwin, 'econ');
        [R, er]            = Compute_elbow(diag(Sr));
        INFO.svals{segind} = diag(Sr(1:R, 1:R)).';
        INFO.svecs{segind} = Ur(:, 1:R);
        INFO.erat(segind)  = er;
    end
    augsegpnts   = [SEGPNTS, T+1];
    INFO.avsegs  = zeros(nchan_e, segind);
    INFO.stdsegs = zeros(nchan_e, segind);
    for seg = 1:segind
        INFO.avsegs(:, seg)  = mean(EEG(:,augsegpnts(seg):augsegpnts(seg+1)-1), 2);
        INFO.stdsegs(:, seg) = std(EEG(:,augsegpnts(seg):augsegpnts(seg+1)-1), 0, 2);
    end
    bst_progress('set', round(100*(prgrss_factor(1)+1)/prgrss_factor(2)));
end


%% ===== COMPUTE_ELBOW =====
function [ind, erat] = Compute_elbow(x)
    %  [ind, erat] = Compute_elbow(x)

    % Curve elbowing.
    % x    = length N vector.
    % ind  = index of the sample before the elbow.
    % erat = ratio of energy in the curve down to ind.

    N        = length(x);
    dx       = x(1:N-2) -2*x(2:N-1) + x(3:N);
    [~, ind] = max(dx);
    erat     = x(1:ind)'*x(1:ind) / (x'*x);
end