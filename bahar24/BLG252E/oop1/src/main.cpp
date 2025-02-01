//--- 2023-2024 Spring BLG 252E Object Oriented Programing Assignment 1 ---//
//--------------------------//
//---Name & Surname: Hilal Kartal
//---Student Number: 150210087
//--------------------------//

//-------------Do Not Add New Libraries-------------//
//-------------All Libraries Needed Were Given-------------//
#include <iostream> 
#include <stdio.h>
#include <string.h>
#include <fstream>

#include "../include/pokemon.h"

using namespace std;

//-------------Do Not Change These Global Variables-------------//
int NAME_COUNTER = 0;   //Use this to keep track of the enemy names
int POK_COUNTER = 0;    //Use this to keep track of the pokemon names
int PLAYER_POKEMON_ATTACK = 20; //You don't have to use this variable but its here if you need it
int ENEMY_POKEMON_ATTACK = 10;  //You don't have to use this variable but its here if you need it
//--------------------------------------------------------------//

//---If Necessary Add Your Global Variables Here---// 
// 
//
//
//-------------------------------------------------//

//-------------Do Not Change These Function Definitions-------------//
string* readEnemyNames(const char*);
string* readPokemonNames(const char*);
player characterCreate(string, int);
void mainMenu();
void fightEnemy(player*, string*, string*);
void catchPokemon(player*, string*);
//------------------------------------------------------------------//

//---If Necessary Add Your Function Definitions Here---// 
//
//
//
//-----------------------------------------------------//

//-------------Do Not Change This Function-------------//
int main(int argc, char* argv[]){
	system("clear");

    //---Creating Enemy and Pokemon Name Arrays---//
    string* enemyNames = readEnemyNames(argv[1]);         
    string* pokemonNames = readPokemonNames(argv[2]);

    string playerName;
    int pokemonChoice;

    cout << "Welcome to the Pokemon Game! \n" << endl;
    cout << "Please enter your name: "; 
    cin >> playerName;
    cout << "Please choose one of these pokemons as your pokemon: \n1- Bulbasaur \n2- Charmender \n3- Squirtle \nChoice: ";
    cin >> pokemonChoice;

    //---Character Creation--//
    player newPlayer = characterCreate(playerName, pokemonChoice);
    
    int menuChoice;

    while(true){
        mainMenu(); 
        cin>>menuChoice;

        switch (menuChoice){
        case 1:
            fightEnemy(&newPlayer, enemyNames, pokemonNames);
            break;
        case 2:
            catchPokemon(&newPlayer, pokemonNames);
            break;
        case 3:
            cout<<newPlayer.showPokemonNumber()<<endl;
            break;
        case 4:
            cout<<newPlayer.showPokeballNumber()<<endl;
            break;
        case 5:
            cout<<newPlayer.showBadgeNumber()<<endl;
            break;
        case 6:
            cout << endl;
            cout << "------- Pokedex -------" <<endl;
            newPlayer.playerPokedex.printPokedex();
            break;
        case 7:
            //---Deletes Dynamic Arrays From Memory and Exits---//
            delete[] enemyNames;
            delete[] pokemonNames;
            return EXIT_SUCCESS;
            break;
  
        default:
            cout << "Please enter a valid number!!!" << endl;
            break;
        }
    }
    return EXIT_FAILURE;
};
//-----------------------------------------------------//

//-------------Code This Function-------------//
string* readEnemyNames(const char* argv){
     
    ifstream enemy_names_file(argv);
    if (!enemy_names_file.is_open()) {
        cerr << "enemyNames.txt could not be opened." << endl;
        return NULL;
    }

    int size = 0;
    enemy_names_file >> size;
    string* enemy_names = new string[size];

    //NAME_COUNTER = size;
    
    for (int i = 0; i < size; ++i) {
        enemy_names_file >> enemy_names[i];
    }

    enemy_names_file.close();
    return enemy_names;
};
//-----------------------------------------------------//

//-------------Code This Function-------------//
string* readPokemonNames(const char* argv){
    
    ifstream pokemon_names_file(argv);
    if (!pokemon_names_file.is_open()) {
        cerr << "pokemonNames.txt could not be opened." << endl;
        return NULL;
    }

    int size = 0;
    pokemon_names_file >> size;
    string* pokemon_names = new string[size];

    //POK_COUNTER = size;

    for (int i = 0; i < size; ++i) {
        pokemon_names_file >> pokemon_names[i];
    }

    pokemon_names_file.close();
    return pokemon_names;
};
//-----------------------------------------------------//

//-------------Code This Function-------------//
player characterCreate(string playerName, int pokemonChoice){
    
    string player_pokemon_s;
    if (pokemonChoice == 1) {
        player_pokemon_s = "Bulbasaur";
    }
    else if (pokemonChoice == 2) {
        player_pokemon_s = "Charmender";
    }
    else if(pokemonChoice == 3){
        player_pokemon_s = "Squirtle";
    }
    
    pokemon player_pokemon = pokemon(player_pokemon_s,20);

    player* new_player = new player(playerName, player_pokemon);
    return *new_player;
};
//--------------------------------------------//

//-------------Do Not Change This Function-------------//
void mainMenu(){
    cout << endl;
    cout << "-------- Menu --------" << endl;
    cout << "1. Fight for a badge" << endl;
    cout << "2. Catch a Pokemon" << endl;
    cout << "3. Number of Pokemons" << endl;
    cout << "4. Number of Pokeballs " << endl;
    cout << "5. Number of Badges" << endl;
    cout << "6. Pokedex" << endl;
    cout << "7. Exit" << endl;
    cout << endl;
    cout << "Choice: ";
};
//-----------------------------------------------------//

//-------------Code This Function-------------//
void fightEnemy(player* newPlayer, string* enemyNames, string* pokemonNames){
    string en_pok_name = pokemonNames[POK_COUNTER];
    POK_COUNTER++;
    string en_name = enemyNames[NAME_COUNTER];
    NAME_COUNTER++;

    pokemon* enemy_pokemon = new pokemon(en_pok_name, 10);
    enemy* new_enemy = new enemy(en_name, *enemy_pokemon);
    
    newPlayer->playerPokedex.updatePokedex(enemy_pokemon);

    newPlayer->getPokemon().set_hpValue(100);
    
    cout << "You encounter with " << en_name << " and his/hers pokemon " << en_pok_name << endl;
    cout << en_pok_name << " Health: " << enemy_pokemon->get_hpValue() << " Attack: " << enemy_pokemon->get_atkValue() <<  endl
        << "1- Fight " << endl << "2- Runaway" << endl << "Choice: " << endl;

    string user_choice = " ";
    while (true) {
        cin >> user_choice;
        if (user_choice == "1") {
            int player_hp = newPlayer->getPokemon().get_hpValue();
            int* player_hp_ptr = &player_hp;
	        *player_hp_ptr -= new_enemy->getPokemon().get_atkValue();
            //player_hp -= new_enemy->getPokemon().get_atkValue();
            //newPlayer->getPokemon().set_hpValue(player_hp);

            int enemy_hp = new_enemy->getPokemon().get_hpValue();
            int* enemy_hp_ptr = &enemy_hp;
            *enemy_hp_ptr -= newPlayer->getPokemon().get_atkValue();
            //enemy_hp -= newPlayer->getPokemon().get_atkValue();
            //new_enemy->getPokemon().set_hpValue(enemy_hp);

            cout << "Your Pokemons Healt: " << newPlayer->getPokemon().get_hpValue() << endl
                << en_name << " Pokemons Healt: " << new_enemy->getPokemon().get_hpValue() << endl;
            cout << "1- Fight " << endl << "2- Runaway" << endl << "Choice: " << endl;
            if (new_enemy->getPokemon().get_hpValue() == 0) {
                newPlayer->battleWon();
                cout << "You won!" << endl;
                return;
            }
        }
        else if (user_choice == "2") {
            return;
        }
    } 

    
};
//--------------------------------------------//

//-------------Code This Function-------------//
void catchPokemon(player* newPlayer, string* pokemonNames){
    string seen_pokemon = pokemonNames[POK_COUNTER];
    POK_COUNTER++;

    pokemon* new_pokemon = new pokemon(seen_pokemon, 100);

    string user_choice = " ";
 
    if (user_choice == "1") {
        newPlayer->catchPokemon();
        newPlayer->playerPokedex.updatePokedex(new_pokemon);
        return;
    }
    else if (user_choice == "2") {
        return;
    }
    
    
};
//--------------------------------------------//
