%  Cross-correlazione su segnali audio: riconoscimento
%   del suono attraverso la cross-correlazione 
%    Caricare i segnali audio presenti nel file audioSignals.mat 
%      Le variabili "Y1", "Y2", "Y3"... corrispondono ai primi
%       20 secondi dei segnali audio delle canzoni
%       'funky.mp3', 'lost.mp3', 'Diana.mp3', 'never.mp3',
%       'T69.mp3' (in particolare i segnali corrispondono al primo canale)   
%      La variabile "test" contiene un segnale audio caricato da 'Test.wav' 
%  Confrontare l'esempio di test con le varie canzoni della
%   galleria usando la cross-correlazione: riusciamo a
%   capire da quale canzone proviene?  
%  Suggerimenti:  
%    determinare la similarità tra il segnale di test e ogni
%     canzone tramite la cross-correlazione (si veda  esempio 2 nel flie
%     Lezione3_EserciziPrincipali.m) 
%  determinare la canzone più simile guardando quella
%   con similarità più grande 

%%
% First 20 secs of different audios
workspace = load("../assets/audioSignals.mat");
[funky, lost, diana, never, t69, test] = deal(workspace.Y1, workspace.Y2, workspace.Y3, ...
    workspace.Y4, workspace.Y5, workspace.test);

figure; set(gcf,'name','Dataset canzoni','IntegerHandle','off');
subplot(2,3,1); plot(funky(1:96000*3)); title('Funky');
subplot(2,3,2); plot(lost(1:96000*3)); title('Lost');
subplot(2,3,3); plot(diana(1:96000*3)); title('Diana');
subplot(2,3,4); plot(never(1:96000*3)); title('Never');
subplot(2,3,5); plot(t69(1:96000*3)); title('T69');
subplot(2,3,6); plot(test(1:96000*3)); title('Test Audio');

songs{1} = funky;
songs{2} = lost;
songs{3} = diana;
songs{4} = never;
songs{5} = t69;

max_corr = zeros(5,1);
figure; set(gcf,'name','Risultati di matching','IntegerHandle','off');
for i=1:5
    [correlation{i},lag{i}]= xcorr(songs{i},test); %#ok<SAGROW>
    max_corr(i) = max(correlation{i});
    subplot(2,3,i); plot(lag{i},correlation{i});
end

[~, matched_song] = max(max_corr);
disp('The test audio matches with song' + string(matched_song));
%%
