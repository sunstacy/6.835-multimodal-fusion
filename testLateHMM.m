% Spring 2013 6.835 Intelligent Multimodal Interfaces
%
% [ stat ] = testLateHMM(seqs, labels, hmm, featureMap, weightsMV)
%
% Input
%   seqs       - 1-by-N cell array of test samples
%   labels     - 1-by-N cell array of test labels
%   hmm        - 1-by-2 cell array of trained HMMs
%   featureMap - 1-by-2 cell array of indices defining each modality
%   weightsMV  - 1-by-K cell array of weights we want to validate
%
% Output
%   stat.Ystar     - 1-by-N predicted labels
%   stat.Ytrue     - 1-by-N ground truth labels
%   stat.accuracy  - classification accuracy values

function [ stat ] = testLateHMM(seqs, labels, hmm, featureMap, weightsMV)
% Use hmm{1} and hmm{2} to obtain estimates of log-likelihoods of samples 
% using only body features (and hand features). Then, for each weight value 
% in weightsMV, compute the weighted average of the two log-likelihoods, 
% obtain predicted labels by taking the max of log-likelihoods of each sample, 
% finally compute the accuracy of the estimates. 

    body_seqs = cellfun(@(x) x(featureMap{1},:), seqs, 'UniformOutput', false);
    hand_seqs = cellfun(@(x) x(featureMap{2},:), seqs, 'UniformOutput', false);
    bodyHMM = hmm{1};
    handHMM = hmm{2};
    [bodyYstar, bodyLL] = testHMM(bodyHMM, body_seqs);
    [handYstar, handLL] = testHMM(handHMM, hand_seqs);
    
    stat = cell(1, numel(weightsMV));
    
    for weightIndex = 1:numel(weightsMV)
        stat{weightIndex}.Ystar = zeros(1, numel(seqs));
        stat{weightIndex}.Ytrue = cellfun(@(x) x(1), labels);
        stat{weightIndex}.accuracy = 0;
        
        bodyWeight = weightsMV{weightIndex}(1);
        handWeight = weightsMV{weightIndex}(2);
        correct = 0;
        for sampleIndex = 1:numel(seqs)
            weightedBodyLL = bodyLL{sampleIndex} * bodyWeight;
            weightedHandLL = handLL{sampleIndex} * handWeight;
            avgLL = (weightedBodyLL + weightedHandLL) / 2;
            
            [~, prediction] = max(avgLL);
            stat{weightIndex}.Ystar(sampleIndex) = prediction;
            if prediction == stat{weightIndex}.Ytrue(sampleIndex)
                correct = correct + 1;
            end
        end
        
        stat{weightIndex}.accuracy = correct / numel(seqs);
        
        
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %{
    if ~exist('stat','var') || ~isfield(stat,'Ystar') || ...
            ~isfield(stat,'Ytrue') || ~isfield(stat,'accuracy')
        error('Implement testLateHMM.m');
    end
    if ~(size(stat.Ystar,2)==size(stat.Ytrue,2) && size(stat.Ystar,2)==size(seqs,2))
        error('Something is wrong');
    end
    %}
end 