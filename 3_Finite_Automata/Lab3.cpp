#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <set>
#include <string>
#include <tuple>
using namespace std;

//function to split a string by a delimiter and return a vector of substrings
vector<string> split(const string& str, char delimiter) {
    vector<string> tokens;
    stringstream ss(str);
    string token;
    while (getline(ss, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

//function to parse the finite automaton from a file
void parseFA(const string& fileName,
    set<string>& states,
    set<char>& alphabet,
    vector<tuple<string, char, string>>& transitions,
    string& startState,
    set<string>& finalStates) {
    ifstream file(fileName);

    if (!file.is_open()) {
        cerr << "Error: Could not open file " << fileName << endl;
        return;
    }

    string line;
    while (getline(file, line)) {
        if (line.find("states:") == 0) {
            string stateLine = line.substr(7);
            stateLine.erase(0, stateLine.find_first_not_of(" \t")); //trim leading spaces
            vector<string> stateList = split(stateLine, ',');
            states.insert(stateList.begin(), stateList.end());
        }
        else if (line.find("alphabet:") == 0) {
            string alphabetLine = line.substr(9);
            alphabetLine.erase(0, alphabetLine.find_first_not_of(" \t")); //trim leading spaces
            vector<string> symbols = split(alphabetLine, ',');
            for (const auto& symbol : symbols) {
                if (!symbol.empty()) {
                    alphabet.insert(symbol[0]); //add the first character of each symbol
                }
            }
        }
        else if (line.find("transitions:") == 0) {
            string transitionsLine = line.substr(12);
            vector<string> transitionList = split(transitionsLine, ';'); //split individual transitions by ';' 
            for (const auto& transition : transitionList) {
                vector<string> parts = split(transition, ','); //split <state> from <symbol> by ','
                if (parts.size() == 2) {
                    size_t arrowPos = parts[1].find("->"); //look for the "->" separator
                    if (arrowPos != string::npos) {
                        string symbol = parts[1].substr(0, arrowPos); //extract the symbol
                        string toState = parts[1].substr(arrowPos + 2); //extract destination state
                        if (!symbol.empty() && !toState.empty() && symbol.size() == 1) {
                            transitions.emplace_back(parts[0], symbol[0], toState); //add elements of the transition
                        }
                    }
                }
            }
        }
        else if (line.find("start:") == 0) {
            startState = line.substr(6);
            startState.erase(0, startState.find_first_not_of(" \t")); //trim leading spaces
        }
        else if (line.find("final:") == 0) {
            string finalStatesLine = line.substr(6);
            finalStatesLine.erase(0, finalStatesLine.find_first_not_of(" \t")); //trim leading spaces
            vector<string> finalList = split(finalStatesLine, ',');
            finalStates.insert(finalList.begin(), finalList.end());
        }
    }

    file.close();
}

//function to display the finite automaton components
void displayFA(const set<string>& states,
    const set<char>& alphabet,
    const vector<tuple<string, char, string>>& transitions,
    const string& startState,
    const set<string>& finalStates) {
    cout << "Set of States: ";
    for (const auto& state : states) {
        cout << state << " ";
    }
    cout << endl;

    cout << "Alphabet: ";
    for (const auto& symbol : alphabet) {
        cout << symbol << " ";
    }
    cout << endl;

    cout << "Transitions:" << endl;
    for (const auto& transition : transitions) {
        cout << "  " << get<0>(transition) << " --" << get<1>(transition) << "--> " << get<2>(transition) << endl;
    }

    cout << "Start State: " << startState << endl;

    cout << "Final States: ";
    for (const auto& state : finalStates) {
        cout << state << " ";
    }
    cout << endl;
}

int main() {
    string fileName = "FA.in";

    set<string> states;
    set<char> alphabet;
    vector<tuple<string, char, string>> transitions;
    string startState;
    set<string> finalStates;

    parseFA(fileName, states, alphabet, transitions, startState, finalStates);
    displayFA(states, alphabet, transitions, startState, finalStates);

    return 0;
}
