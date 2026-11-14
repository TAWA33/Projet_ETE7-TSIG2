function tsig2_gui

addpath(genpath(pwd));

BLACK = [0 0 0];

% ================= Figure =================
fig = uifigure('Name','TSIG2 — Marker Extraction', 'Position',[60 60 1320 800], 'Color',[1 1 1]);
try, fig.Theme = 'light'; catch, end   % force thème clair si dispo

gl = uigridlayout(fig,[1 2]);
gl.ColumnWidth  = {350,'1x'};
gl.Padding      = [10 10 10 10];
gl.ColumnSpacing = 10;

% ================= Left Pannel =================
pLeft = uipanel(gl,'Title','Parametres','FontWeight','bold');
gL = uigridlayout(pLeft,[4 1]);
gL.RowHeight    = {'fit','fit','fit','fit'};
gL.Padding      = [2 2 2 2];
gL.RowSpacing   = 6;

% ----- Signal -----
pSig = uipanel(gL,'Title','Signal');
gS = uigridlayout(pSig,[3 2]);
gS.RowHeight    = repmat({26},1,3);
gS.ColumnWidth  = {'fit','1x'};
gS.Padding      = [6 6 6 6];
gS.RowSpacing   = 4;

uilabel(gS,'Text','Type');
ddCase = uidropdown(gS, 'Items',{'White Noise','AR(2)','RIF 4 zeros','RII 4 poles'}, 'ItemsData',{'wgn','ar2','rif','rii'});

uilabel(gS,'Text','Samples M');
edM = uieditfield(gS,'numeric','Value',2000, 'Limits',[500 1e5],'RoundFractionalValues','on');

uilabel(gS,'Text','Seed');
edSeed = uieditfield(gS,'numeric','Value',0, 'RoundFractionalValues','on');

% ----- Trend -----
pT = uipanel(gL,'Title','Trend');
gT = uigridlayout(pT,[6 2]);
gT.RowHeight    = {26,26,26,26,26,32};
gT.ColumnWidth  = {'fit','1x'};
gT.Padding      = [6 6 6 6];
gT.RowSpacing   = 4;

uilabel(gT,'Text','Method');
ddTr = uidropdown(gT, ...
    'Items',{'2a - mean','2a - polynomial','2b - mean RIF', '2c - Zero-Phase Filter 1','2c - Zero-Phase Filter 2'}, 'ItemsData',{'2a0','2ak','2b','2c1','2c2'}, 'Value','2c2','ValueChangedFcn',@(~,~) update_trend_enable());

uilabel(gT,'Text','Degree k');
edK = uieditfield(gT,'numeric','Value',1, 'Limits',[1 5],'RoundFractionalValues','on');

uilabel(gT,'Text','Window N');
edN = uieditfield(gT,'numeric','Value',50, 'Limits',[3 1e5],'RoundFractionalValues','on');

uilabel(gT,'Text','Integration step');
cbInt = uicheckbox(gT,'Text','activated','Value',true, 'ValueChangedFcn',@(~,~) update_compare_enable());

uilabel(gT,'Text','Compare');
cbCmp = uicheckbox(gT,'Text','without integration','Value',true);

b1 = uibutton(gT,'Text','Compute Marker','FontWeight','bold', 'ButtonPushedFcn',@(~,~) run_marker());
b1.Layout.Row = 6; b1.Layout.Column = [1 2];

% ----- PSD -----
pP = uipanel(gL,'Title','PSD');
gP = uigridlayout(pP,[6 2]);
gP.RowHeight    = {26,26,26,26,26,32};
gP.ColumnWidth  = {'fit','1x'};
gP.Padding      = [6 6 6 6];
gP.RowSpacing   = 4;

uilabel(gP,'Text','Estimateur');
ddPsd = uidropdown(gP, ...
    'Items',{'Périodogram','Daniell','Bartlett','Welch','Correlogram'}, ...
    'ItemsData',{'periodo','daniell','bartlett','welch','correlo'}, ...
    'Value','welch','ValueChangedFcn',@(~,~) update_psd_enable());

uilabel(gP,'Text','M Daniell');
edMd = uieditfield(gP,'numeric','Value',11, 'Limits',[3 99],'RoundFractionalValues','on');

uilabel(gP,'Text','Window (M)');
edMbw = uieditfield(gP,'numeric','Value',256, 'Limits',[8 1e5],'RoundFractionalValues','on');

uilabel(gP,'Text','Overlap k');
edKw = uieditfield(gP,'numeric','Value',2, 'Limits',[2 20],'RoundFractionalValues','on');

uilabel(gP,'Text','Gap L max');
edLc = uieditfield(gP,'numeric','Value',200, 'Limits',[1 1e5],'RoundFractionalValues','on');

b2 = uibutton(gP,'Text','Compute PSD est.','FontWeight','bold', 'ButtonPushedFcn',@(~,~) run_psd());
b2.Layout.Row = 6; b2.Layout.Column = [1 2];

% ----- Actions -----
pA = uipanel(gL,'Title','Comparison');
gA = uigridlayout(pA,[1 1]);
gA.RowHeight = {'fit'};
gA.Padding   = [6 6 6 6];

b3 = uibutton(gA,'Text','Slope vs Nb Samples  (500 → 5000)', 'ButtonPushedFcn',@(~,~) run_slope_vs_M());

tg = uitabgroup(gl);


t1 = uitab(tg,'Title','Marker');
g1 = uigridlayout(t1,[3 1]);
g1.RowHeight    = {'fit',130,'1x'};
g1.Padding      = [8 8 8 8];
g1.RowSpacing   = 6;

lblResult = uilabel(g1, 'Text','Waiting — Press to Compute', 'FontSize',14,'FontWeight','bold', 'FontColor',BLACK, 'HorizontalAlignment','center', 'BackgroundColor',[0.93 0.93 0.85], 'WordWrap','on');

g1b = uigridlayout(g1,[1 2]);
g1b.Layout.Row     = 2;
g1b.RowHeight      = {'1x'};
g1b.ColumnWidth    = {'1x','1x'};
g1b.Padding        = [0 0 0 0];
g1b.ColumnSpacing  = 6;
ax1 = uiaxes(g1b);
ax2 = uiaxes(g1b);

ax3 = uiaxes(g1);
ax3.Layout.Row = 3;

% --- PSD ---
t2 = uitab(tg,'Title','PSD');
ax4 = uiaxes(uigridlayout(t2,[1 1]));

% --- Slope vs Nb Samples ---
t3 = uitab(tg,'Title','Slope vs Samples');
ax5 = uiaxes(uigridlayout(t3,[1 1]));

axesList = [ax1 ax2 ax3 ax4 ax5];
for ax = axesList
    style_axes(ax);
end

update_trend_enable();
update_compare_enable();
update_psd_enable();

% ================= Enable / Disable =================
    function update_trend_enable()
        edK.Enable = strcmp(ddTr.Value,'2ak');
    end
    function update_compare_enable()
        cbCmp.Enable = cbInt.Value;
    end
    function update_psd_enable()
        v = ddPsd.Value;
        edMd.Enable  = strcmp(v,'daniell');
        edMbw.Enable = any(strcmp(v,{'bartlett','welch'}));
        edKw.Enable  = strcmp(v,'welch');
        edLc.Enable  = strcmp(v,'correlo');
    end

    function run_marker()
        dlg = [];
        try
            M = edM.Value;
            [x, name] = get_signal(M);
            f  = get_trend_fun();
            y  = make_profile(x);

            if M > 3000
                dlg = uiprogressdlg(fig,'Title','Computing', 'Message','Marker Estimation...', 'Indeterminate','on');
            end

            [Nv, P, coef, slope] = compute_power_proc_r(y, f);

            % --- x(n) ---
            cla(ax1);
            plot(ax1, x, 'LineWidth', 0.6);
            title(ax1, sprintf('Signal %s — x(n), M = %d', name, M));
            xlabel(ax1,'n'); ylabel(ax1,'x(n)');
            ax1.XLim = [1 M];
            style_axes(ax1);

            % --- y(n) + local trend ---
            cla(ax2);
            Nw = max(3, min(edN.Value, floor(M/2)));
            tr = f(y, Nw);
            t  = 1:min(20*Nw, M);
            plot(ax2, t, y(t), 'b-', 'LineWidth', 1.0); hold(ax2,'on');
            plot(ax2, t, tr(t), 'r-', 'LineWidth', 1.6); hold(ax2,'off');
            title(ax2, sprintf('y(n) and local trend — N = %d', Nw));
            xlabel(ax2,'n'); ylabel(ax2,'amplitude');
            add_legend(ax2,{'y(n)','trend'});
            style_axes(ax2);

            % --- Marker log-log ---
            cla(ax3);
            plot(ax3, Nv, P, 'o', 'MarkerSize', 3, 'MarkerFaceColor','b','MarkerEdgeColor','b'); hold(ax3,'on');
            plot(ax3, Nv, exp(polyval(coef, log(Nv))), 'r-', 'LineWidth', 2);
            txt = sprintf('Slope = %.3f', slope);
            leg = {'P(N)','ajustement'};

            if cbCmp.Value && cbInt.Value
                [Nx, Px, cx, sx] = compute_power_proc_r(x, f);
                plot(ax3, Nx, Px, 's', 'MarkerSize', 3, 'MarkerFaceColor','g','MarkerEdgeColor','g');
                plot(ax3, Nx, exp(polyval(cx, log(Nx))), 'k-', 'LineWidth', 2);
                txt = sprintf('Slope with int. = %.3f  |  without = %.3f', slope, sx);
                leg = {'With int.','Ajust. With','Without int.','Ajust. Without'};
            end
            hold(ax3,'off');
            set(ax3,'XScale','log','YScale','log');
            xlabel(ax3,'N'); ylabel(ax3,'P(N)');
            title(ax3, sprintf('P(N) in log-log — %s', txt));
            add_legend(ax3, leg);
            style_axes(ax3);

            % --- Results ---
            if cbCmp.Value && cbInt.Value
                lblResult.Text = sprintf('Slope : With integration = %.3f   |   Without = %.3f   —   %s, M = %d', slope, sx, name, M);
            else
                lblResult.Text = sprintf('Slope estimated= %.3f   —   %s, M = %d, method %s', slope, name, M, ddTr.Value);
            end

            tg.SelectedTab = t1;
        catch err
            if ~isempty(dlg), close(dlg); end
            uialert(fig, err.message, 'Error');
            return;
        end
        if ~isempty(dlg), close(dlg); end
    end

    function run_psd()
        try
            M = edM.Value;
            [x, name, info] = get_signal(M);
            if isfield(info,'h')
                fth = info.fn; DSP = abs(info.h).^2;
            else
                fth = [-0.5 0.5]; DSP = [1 1];
            end

            switch ddPsd.Value
                case 'periodo'
                    [P, fn] = periodo(x); estName = 'Periodogram';
                case 'daniell'
                    M_D = edMd.Value;
                    if mod(M_D,2)==0, M_D = M_D+1; end
                    if M_D >= M
                        error('Daniell : M_D must be < M.');
                    end
                    [P, fn] = Daniell_periodogram(x, M_D); estName = 'Daniell';
                case 'bartlett'
                    [P, fn] = Bartlett_periodogram(x, edMbw.Value);
                    estName = 'Bartlett';
                case 'welch'
                    [P, fn] = Welch_periodogram(x, edMbw.Value, edKw.Value);
                    estName = 'Welch';
                case 'correlo'
                    [P, fn] = correlogram(x, edLc.Value); P = real(P);
                    estName = 'Correlogram';
            end

            cla(ax4);
            plot(ax4, fn, 10*log10(P), 'b-', 'LineWidth', 1.5); hold(ax4,'on');
            plot(ax4, fth, 10*log10(DSP), 'r--', 'LineWidth', 1.8); hold(ax4,'off');
            xlabel(ax4,'Normalized frequency'); ylabel(ax4,'DSP (dB)');
            title(ax4, sprintf('%s — %s', estName, name));
            add_legend(ax4,{'Estimation','DSP th.'});
            style_axes(ax4);

            tg.SelectedTab = t2;
        catch err
            uialert(fig, err.message, 'Error');
        end
    end

    function run_slope_vs_M()
        Ms = [500 1000 2000 3000 5000];
        s  = zeros(size(Ms));
        d  = uiprogressdlg(fig,'Title','Slope vs Samples', 'Message','Launching...','Value',0);
        try
            f = get_trend_fun();
            for i = 1:numel(Ms)
                d.Message = sprintf('M = %d  (%d/%d)', Ms(i), i, numel(Ms));
                d.Value   = (i-1)/numel(Ms);
                [x, name] = get_signal(Ms(i));
                [~, ~, ~, s(i)] = compute_power_proc_r(make_profile(x), f);
            end
            cla(ax5);
            plot(ax5, Ms, s, 'o-', 'LineWidth', 1.8, 'MarkerSize', 8, 'MarkerFaceColor','b','MarkerEdgeColor','b');
            xlabel(ax5,'M (samples)'); ylabel(ax5,'Estimated slope');
            title(ax5, sprintf('%s — slope vs M', name));
            style_axes(ax5);
            tg.SelectedTab = t3;
        catch err
            close(d);
            uialert(fig, err.message, 'Error');
            return;
        end
        close(d);
    end

    function [x, name, info] = get_signal(M)
        rng(edSeed.Value);
        switch ddCase.Value
            case 'wgn', [~, x, info] = case_wgn(M);       name = 'WGN';
            case 'ar2', [~, x, info] = case_ar2(M);       name = 'AR(2)';
            case 'rif', [~, x, info] = case_rif_zeros(M); name = 'RIF 4 zeros';
            case 'rii', [~, x, info] = case_rii_poles(M); name = 'RII 4 poles';
        end
    end

    function f = get_trend_fun()
        switch ddTr.Value
            case '2a0', f = @(y,N) proc_trend_2a(y, N, 0);
            case '2ak', f = @(y,N) proc_trend_2a(y, N, edK.Value);
            case '2b',  f = @proc_trend_2b;
            case '2c1', f = @proc_trend_2c1;
            case '2c2', f = @proc_trend_2c2;
        end
    end

    function y = make_profile(x)
        if cbInt.Value
            y = integrate_signal(x);
        else
            y = x - mean(x);
        end
    end

    function style_axes(ax)
        ax.FontSize   = 11;
        ax.Box        = 'on';
        ax.XGrid      = 'on';
        ax.YGrid      = 'on';
        ax.Color      = [1 1 1]; 
        ax.XColor     = [0 0 0];
        ax.YColor     = [0 0 0];
        ax.GridColor  = [0.2 0.2 0.2];
        ax.GridAlpha  = 0.2;
        ax.Title.Color  = [0 0 0];
        ax.XLabel.Color = [0 0 0];
        ax.YLabel.Color = [0 0 0];
    end

    function lgd = add_legend(ax, labels)
        lgd = legend(ax, labels, 'Location','best');
        lgd.TextColor = [0 0 0]; 
        lgd.Color     = [1 1 1]; 
        lgd.EdgeColor = [0.3 0.3 0.3];
        lgd.FontSize  = 10;
    end
end