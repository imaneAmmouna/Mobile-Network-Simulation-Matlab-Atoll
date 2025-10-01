function modulation_FSK_GUI()
    % Fen?tre FSK
    f = figure('Name','Modulation FSK', 'Position',[100 100 700 400]);
    
    % Param?tres initiaux
    N = 8;
    data = randi([0 1],1,N);
    Tb = 1;         % Dur?e du bit (s)
    f1 = 3;         % Fr?quence pour bit 0 (Hz)
    f2 = 7;         % Fr?quence pour bit 1 (Hz)
    Fs = 100;       % Fr?quence d'?chantillonnage (Hz)
    
    % Axe pour le signal
    ax = axes('Parent',f,'Position',[0.1 0.35 0.85 0.6]);
    
    % Affichage bits
    bits_text = uicontrol('Style','text','Units','normalized','Position',[0.1 0.28 0.8 0.05],...
        'String',sprintf('Bits: %s', num2str(data)));
    
    % Sliders et labels
    uicontrol('Style','text','Units','normalized','Position',[0.1 0.2 0.15 0.05], 'String','Tb (s)');
    slider_Tb = uicontrol('Style','slider','Units','normalized','Min',0.2,'Max',3,...
        'Value',Tb,'Position',[0.25 0.2 0.6 0.05],'Callback',@updatePlot);
    
    uicontrol('Style','text','Units','normalized','Position',[0.1 0.14 0.15 0.05], 'String','f1 (Hz)');
    slider_f1 = uicontrol('Style','slider','Units','normalized','Min',1,'Max',10,...
        'Value',f1,'Position',[0.25 0.14 0.6 0.05],'Callback',@updatePlot);
    
    uicontrol('Style','text','Units','normalized','Position',[0.1 0.08 0.15 0.05], 'String','f2 (Hz)');
    slider_f2 = uicontrol('Style','slider','Units','normalized','Min',1,'Max',15,...
        'Value',f2,'Position',[0.25 0.08 0.6 0.05],'Callback',@updatePlot);
    
    uicontrol('Style','text','Units','normalized','Position',[0.1 0.02 0.15 0.05], 'String','Fs (Hz)');
    slider_Fs = uicontrol('Style','slider','Units','normalized','Min',50,'Max',200,...
        'Value',Fs,'Position',[0.25 0.02 0.6 0.05],'Callback',@updatePlot);
    
    % Bouton pour nouveaux bits
    btn_newBits = uicontrol('Style','pushbutton','Units','normalized','String','Nouveaux bits',...
        'Position',[0.4 0.90 0.2 0.05],'Callback',@newBits);
    
    % Fonction mise ? jour plot
    function updatePlot(~,~)
        Tb = get(slider_Tb,'Value');
        f1 = get(slider_f1,'Value');
        f2 = get(slider_f2,'Value');
        Fs = round(get(slider_Fs,'Value'));
        
        t = 0:1/Fs:Tb-1/Fs;
        time_full = linspace(0, N*Tb, N*length(t));
        
        fsk_signal = [];
        for i=1:N
            if data(i)==1
                fsk_signal = [fsk_signal cos(2*pi*f2*t)];
            else
                fsk_signal = [fsk_signal cos(2*pi*f1*t)];
            end
        end
        
        plot(ax, time_full, fsk_signal, 'r','LineWidth',1.5);
        title(ax, 'Modulation FSK');
        xlabel(ax, 'Temps (s)');
        ylabel(ax, 'Amplitude');
        grid(ax,'on');
        
        set(bits_text, 'String', sprintf('Bits: %s', num2str(data)));
    end

    % Fonction nouveaux bits
    function newBits(~,~)
        data = randi([0 1],1,N);
        updatePlot();
    end

    % Affichage initial
    updatePlot();
end
