%% Agent-based models of date choice.

% Decription: This model replicates two of the agent-based models (ABMs) of
% human date choice, developed by Kalick and Hamilton (1986).

% Input: The inputs to this function are the number of agents/suitors/
% couples to be simulated, and the ABM date choice rule to apply.
% By specifying either 'similarity' or 'attractiveness' in the input when
% calling this function, the specified ABM will used to simulate romantic
% coupling processes for a chosen number of agents/suitors/couples.

% Output: The output of this function is the intra-couple attractiveness
% correlation - the extent of similarity between the attractiveness scores
% of agents and suitors in the successfully paired couples. 

% Created: 19/05/2023, 2532577.

function correlation = runKalickHamilton(nAgents, choiceRule)

% Create agents of random attractiveness.
agents = randi(10, 1, nAgents);

% Create suitors of random attractiveness.
suitors = randi(10, 1, nAgents);

% Create empty array to store couples.
couples = [];

% Create date counter for while loop.
iDate = 1;

% Initialise vectors to count dates.
suitorDateCounts = zeros(1, length(suitors));
agentDateCounts = zeros(1, length(agents));

% While there are single agents:
while ~isempty(agents) == 1
    
    % If dates couple based on agent-suitor attractiveness similarity:
    if strcmp(choiceRule, "similarity")

        % Randomly select agent.
        sampleAgentIdx = randsample(1:length(agents), 1);
        sampleAgent = agents(sampleAgentIdx);
        agentDateCounts(sampleAgentIdx) = agentDateCounts(sampleAgentIdx) + 1;
        
        % Randomly select suitor.
        sampleSuitorIdx = randsample(1:length(suitors), 1);
        sampleSuitor = suitors(sampleSuitorIdx);
        suitorDateCounts(sampleSuitorIdx) = suitorDateCounts(sampleSuitorIdx) + 1;

        % Calculate coupling probability based on agent-suitor similarity.
        agentMatchProb = (10 - abs(sampleAgent - sampleSuitor))^3 / 1000;
        agentMatchProb = agentMatchProb^((51 - agentDateCounts(sampleAgentIdx)) / 50);

        % Calculate coupling probability based on suitor-agent similarity.
        suitorMatchProb = (10 - abs(sampleSuitor - sampleAgent))^3 / 1000;
        suitorMatchProb = suitorMatchProb^((51 - suitorDateCounts(sampleSuitorIdx)) / 50);

        % Use probability to decide whether to couple.
        decisionMaker = rand(1);
        if agentMatchProb > decisionMaker && suitorMatchProb > decisionMaker
            couples(iDate, 1) = sampleAgent;
            couples(iDate, 2) = sampleSuitor;
            agents(sampleAgentIdx) = [];
            suitors(sampleSuitorIdx) = [];
        end
    
    % If dates couple based on suitor attractiveness:
    elseif strcmp(choiceRule, "attractiveness")

        % Randomly select agent.
        sampleAgentIdx = randsample(1:length(agents), 1);
        sampleAgent = agents(sampleAgentIdx);
        agentDateCounts(sampleAgentIdx) = agentDateCounts(sampleAgentIdx) + 1;
        
        % Randomly select suitor.
        sampleSuitorIdx = randsample(1:length(suitors), 1);
        sampleSuitor = suitors(sampleSuitorIdx);
        suitorDateCounts(sampleSuitorIdx) = suitorDateCounts(sampleSuitorIdx) + 1;

        % Determine agent's coupling probability.
        agentMatchProb = sampleSuitor^3 / 1000;
        agentMatchProb = agentMatchProb^((51 - agentDateCounts(sampleAgentIdx)) / 50);

        % Determine suitor's coupling probability.
        suitorMatchProb = sampleAgent^3 / 1000;
        suitorMatchProb = suitorMatchProb^((51 - suitorDateCounts(sampleSuitorIdx)) / 50);

        % Use probability to decide whether to couple.
        decisionMaker = rand(1);
        if agentMatchProb > decisionMaker && suitorMatchProb > decisionMaker
            % Form couple, remove from dating pool.
            couples(iDate, 1) = sampleAgent;
            couples(iDate, 2) = sampleSuitor;
            agents(sampleAgentIdx) = [];
            suitors(sampleSuitorIdx) = [];
        end

    else
        % Display error if wrong input used.
        error("choiceRule must be 'similarity' or 'attractiveness'.")
    end
    
% Proceed to next date.
iDate = iDate + 1;

end

% Remove rows of zeros (unsuccessful dates) from couples array.
successfulDates = any(couples, 2);
couples = couples(successfulDates, :);

% Calculate correlation between coupled agents and suitors.
correlation = corrcoef(couples);
correlation = correlation(2, 1);

% Plot intra-couple attractiveness correlation.
coefficients = polyfit(couples(:, 1), couples(:, 2), 1);
bestFitLine = polyval(coefficients, couples(:, 1));
plot(couples(:, 1), bestFitLine, "LineWidth", 2)
title("Intra-couple attractiveness correlation")
xlabel("Agent attractiveness")
ylabel("Suitor attractiveness")
axis([1 10 1 10])
grid on

end
