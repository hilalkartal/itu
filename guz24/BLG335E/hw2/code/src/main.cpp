#include "methods.h"
//to time functions
#include <chrono>

int main() 
{
  /*
+  std::vector<Item> items = readItemsFromFile("data/items_l.csv");
+  std::vector<Item> sorted = countingSort(items, "age", true);
+  writeItemsToFile("data/items_l_sorted.csv", sorted);
+  calculateRarityScores(sorted, 50);
+  writeItemsToFile("data/items_l_rarity.csv", sorted);
+  sorted = heapSortByRarity(sorted, true);
+  writeItemsToFile("data/items_l_rarity_sorted.csv", sorted);
  */

  /*
  std::vector<Item> items_large = readItemsFromFile("data/items_l.csv");
  std::vector<Item> items_medium = readItemsFromFile("data/items_m.csv");
  std::vector<Item> items_small = readItemsFromFile("data/items_s.csv");

  std::cout << "------------------- For CountSort ------------------------" <<std::endl;
  
  auto start = std::chrono::high_resolution_clock::now();
  std::vector<Item> sorted_large = countingSort(items_large, "age", true);
  auto end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> duration = end - start;
  std::cout << "Execution time for items_large: " << duration.count() << " seconds" << std::endl;
  //writeItemsToFile("data/items_l_sorted.csv", sorted_large);

  start = std::chrono::high_resolution_clock::now();
  std::vector<Item> sorted_medium = countingSort(items_medium, "age", true);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for sorted_medium " << duration.count() << " seconds" << std::endl;
  //writeItemsToFile("data/items_m_sorted.csv", sorted_medium);

  start = std::chrono::high_resolution_clock::now();
  std::vector<Item> sorted_small = countingSort(items_small, "age", true);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for sorted_small " << duration.count() << " seconds" << std::endl;
  //writeItemsToFile("data/items_s_sorted.csv", sorted_small);

  std::cout << "------------------- For Rarity Scores ------------------------" <<std::endl;
  
  start = std::chrono::high_resolution_clock::now();
  calculateRarityScores(sorted_large, 50);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for sorted_large " << duration.count() << " seconds" << std::endl;
  
  start = std::chrono::high_resolution_clock::now();
  calculateRarityScores(sorted_medium, 50);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for sorted_medium " << duration.count() << " seconds" << std::endl;

  start = std::chrono::high_resolution_clock::now();
  calculateRarityScores(sorted_small, 50);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for sorted_small " << duration.count() << " seconds" << std::endl;
  
  std::cout << "------------------- For HeapSort ------------------------" <<std::endl;

  start = std::chrono::high_resolution_clock::now();
  heapSortByRarity(sorted_large, true);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for sorted_large " << duration.count() << " seconds" << std::endl;

  start = std::chrono::high_resolution_clock::now();
  heapSortByRarity(sorted_medium, true);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for sorted_medium " << duration.count() << " seconds" << std::endl;

  start = std::chrono::high_resolution_clock::now();
  heapSortByRarity(sorted_small, true);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for sorted_small " << duration.count() << " seconds" << std::endl;
  */

  
  
  std::vector<Item> items_50window = readItemsFromFile("data/items_l.csv");
  std::vector<Item> items_10window = readItemsFromFile("data/items_l.csv");
  std::vector<Item> items_100window = readItemsFromFile("data/items_l.csv");
  std::vector<Item> items_25window = readItemsFromFile("data/items_l.csv");

  std::vector<Item> sorted_50 = countingSort(items_50window, "age", true);
  std::vector<Item> sorted_10 = countingSort(items_10window, "age", true);
  std::vector<Item> sorted_100 = countingSort(items_100window, "age", true);
  std::vector<Item> sorted_25 = countingSort(items_25window, "age", true);
  std::cout << "------------------- For RarityScore Calculation ------------------------" <<std::endl;
  
  
  
  auto start = std::chrono::high_resolution_clock::now();
  calculateRarityScores(sorted_100, 100);
  auto end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> duration = end - start;
  std::cout << "Execution time for age window 100: " << duration.count() << " seconds" << std::endl;

  start = std::chrono::high_resolution_clock::now();
  calculateRarityScores(sorted_50, 50);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for age window 50: " << duration.count() << " seconds" << std::endl;

  start = std::chrono::high_resolution_clock::now();
  calculateRarityScores(sorted_25, 25);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for age window 25: " << duration.count() << " seconds" << std::endl;

  start = std::chrono::high_resolution_clock::now();
  calculateRarityScores(sorted_10, 10);
  end = std::chrono::high_resolution_clock::now();
  duration = end - start;
  std::cout << "Execution time for age window 10: " << duration.count() << " seconds" << std::endl;
  return 0;
}