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

#include "../include/pokemon.h"

using namespace std;

//-------------You Can Add Your Functions Down Below-------------//
pokemon::pokemon() {
	this->name = " ";
	this->atkValue = 0;
	this->hpValue = 0;
}

pokemon::pokemon(string pokemon_name, int attack_value) {
	name = pokemon_name;
	atkValue = attack_value;
	hpValue = 100;
}

pokemon::pokemon(const pokemon& ori_pokemon) {
	name = ori_pokemon.name;
	atkValue = ori_pokemon.atkValue;
	hpValue = ori_pokemon.hpValue;
}

string pokemon::get_name() {
	return this->name;
}

int pokemon::get_hpValue() {
	return this->hpValue;
}

int pokemon::get_atkValue(){
	return this->atkValue;
}

void pokemon::set_hpValue(int new_hpValue) {
	hpValue = new_hpValue;
}

pokedex::pokedex() {
	this->value = 0;
}

//bu fonsiyon void yapılıp returnler de silinebilir.
bool pokedex::updatePokedex(pokemon* new_pokemon) {
	for (int i = 0; i <= value; i++) {
		if (pokedexArray[i].get_name() == new_pokemon->get_name()) {
			cout << "This pokemon is already in the Pokedex." << endl;
			return false;
		}
		else if (pokedexArray[i].get_name() == " ") {
			pokedexArray[i] = *new_pokemon;
			value++;
			return true;
		}
	}
	cout << "Pokedex full!" << endl;
	return true;
}

void pokedex::printPokedex() {
	int i = 0;
	while (pokedexArray[i].get_name() != " ") {
		cout << pokedexArray[i].get_name() << endl;
		i++;
	}
}

player::player() {
	this->name = " ";
	this->pokemonNumber = 0;
	this->pokeballNumber = 0;
	this->badgeNumber = 0;
	this->playerPokemon = pokemon();
	this->playerPokedex = pokedex();
}

player::player(string player_name, pokemon player_pokemon) {
	name = player_name;
	playerPokemon = player_pokemon;
	pokemonNumber = 1;
	pokeballNumber = 10;
	badgeNumber = 0;
	//playerPokedex.updatePokedex(&player_pokemon);
}

int player::showPokemonNumber() {
	return this->pokemonNumber;
}

int player::showPokeballNumber() {
	return this->pokeballNumber;
}

int player::showBadgeNumber() {
	return this->badgeNumber;
}

pokemon player::getPokemon() {
	return this->playerPokemon;
}

void player::battleWon() {
	badgeNumber++;
	pokeballNumber = pokeballNumber + 3;
}

void player::catchPokemon() {
	pokemonNumber++;
	pokeballNumber--;
}

enemy::enemy() {
	this->name = " ";
	this->enemyPokemon = pokemon();
}

enemy::enemy(string enemy_name, pokemon enemy_pokemon) {
	name = enemy_name;
	enemyPokemon = enemy_pokemon;
}

pokemon enemy::getPokemon() {
	return this->enemyPokemon;
}

string enemy::getName() {
	return this->name;
}
