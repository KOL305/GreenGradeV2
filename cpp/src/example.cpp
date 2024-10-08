#include <android/log.h>
#include <gmp.h>
#include <sstream>
#include <algorithm>
#include <array>
#include <cmath>
#include <fstream>
#include <iostream>
#include <limits>
#include <vector>
#include <map>
#include <sstream>
#include <tuple>

#define LOG_TAG "ExampleFunction"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)


// extern "C" void example_function() {
//     LOGI("example_function called");

//     mpz_t a, b, result;
//     mpz_init_set_str(a, "1234", 10);
//     mpz_init_set_str(b, "5678", 10);
//     mpz_init(result);

//     mpz_add(result, a, b);

//     // Convert GMP result to a string
//     char *result_str = mpz_get_str(NULL, 10, result);
//     LOGI("Calculation result: %s", result_str);

//     // Free the memory allocated by mpz_get_str
//     free(result_str);

//     mpz_clear(a);
//     mpz_clear(b);
//     mpz_clear(result);
// }

// extern "C" int add(int a, int b){
//     return a + b;
// }

extern "C" int add() {
  return 1+1;
}



std::vector<std::vector<double>> BIbreaks;
std::vector<std::vector<double>> BIints;
std::map<std::string, int> variables;
std::vector<double> xbps(7, 0.0);
std::vector<std::vector<double>> xebs;
std::vector<double> xeb(8, 0.0);
std::vector<std::vector<double>> newXebs;
std::vector<int> xebsIteration;
std::vector<double> mu0(3, 0.0);
std::vector<std::vector<double>> mu0grades;
std::vector<std::vector<double>> mu1s;
std::vector<std::vector<double>> combos;
std::vector<double> combosRow;
std::vector<std::vector<int>> rs;
std::vector<std::vector<int>> rsHUMS(3125, std::vector<int>(6, 0));
std::vector<std::vector<double>> ActualInts;
std::vector<int> Lingvars1 = {1, 2, 3, 4, 5};
double SIIvalue; 
int numBI;
int counter;
using namespace std;
int numCategories = 1;
std::vector<double> numBIcategory;
int localLength;
 int test =1;
string BIintsConst = 
"5932.772365	5932.772365\n"
"7673.782108	7673.782108\n"
"61.5	61.5\n"
"11.75942918	11.75942918\n"
"7670504.872	7670504.872\n"
"4609.911426	4609.911426\n"
"21.07362861	21.07362861\n"
"11248893000000	11248893000000\n"
"20.6	20.6\n"
"3222.763508	3222.763508\n"
"224.7121346	224.7121346\n"
"1018.689105	1018.689105\n"
"0.12	0.12\n"
"78944	101624\n"
"1211691.763	1211691.763";



string BIbreaksConst = 
"0 0 337.8571429 3161.964286 0.2 1 1\n"
"0 0 6.3162299482 14.21151738 0.2 1 1\n"
"27.5 80 0 0 0.2 2 1\n"
"0 0 0 0 0.5 2 1\n"
"0 0 514.2857143 13014.28571 0.2 1 2\n"
"0 0 0.156 0.5788904892 0.6 1 2\n"
"0 0 0 0 0.7 2 2\n"
"0 0 154395234845 201046511600 0.2 1 3\n"
"10 60 0 0 0.2 2 3\n"
"0 0 1.036783 2.72155425 0.2 1 4\n"
"0.2146345 1.78845 0 0 0.2 2 4\n"
"0 0 0.08844882 0.22357892 0.2 1 4\n"
"0.3 0.9 1.2 2.6 0.5 3 5\n"
"31090 96500 0 0 0.5 2 5\n"
"500000 2064705.882 0 0 0.5 2 5";

string ActualIntsConst = 
"3333.215235 3333.215235";

std::vector<string> BIlist;


void increaseRuntime(){
  int counterBIints = 0;
  for (int i = 0; i < BIints.size(); i++){
    if (!(BIints[i][0] == BIints[i][1])){
      counterBIints++;
    }
  }
  int average;
  //int countercounter = 15;

    int i = 0; 
    while (counterBIints > 1 && i <= 14){
      if (!(BIints[i][0] == BIints[i][1]) && i != 0 && i != 4 ){
        average = (BIints[i][0] + BIints[i][1])/2;
        BIints[i][0] = average;
        BIints[i][1] = average;
        counterBIints--;
      }
      i++;
    }
}

void addSums(int arr[], int len, int x) {
    int combinations = pow(len, numBIcategory[x]);

    // Resize rs to fit all combinations
    int startIndex = rs.size();
    rs.resize(startIndex + combinations, vector<int>(numBIcategory[x] + 1, 0));

    // Calculate the minimum and maximum possible sums
    int minSum = numBIcategory[x];
    int maxSum = 3 * numBIcategory[x];
    double step = static_cast<double>(maxSum - minSum) / 4.5;

    for (int k = 0; k < combinations; k++) {
        int sum = 0;
        int temp = k;
        for (int i = 0; i < numBIcategory[x]; i++) {
            rs[startIndex + k][i] = arr[temp % len];
            sum += rs[startIndex + k][i];
            temp /= len;
        }
        rs[startIndex + k][numBIcategory[x]] = sum;  // Storing the sum as the last element

        // Determine the category for the sum
        if (sum <= minSum + step) {
            rs[startIndex + k][numBIcategory[x]] = 1;
        } else if (sum <= minSum + 2 * step) {
            rs[startIndex + k][numBIcategory[x]] = 2;
        } else if (sum <= minSum + 3 * step) {
            rs[startIndex + k][numBIcategory[x]] = 3;
        } else if (sum <= minSum + 4 * step) {
            rs[startIndex + k][numBIcategory[x]] = 4;
        } else {
            rs[startIndex + k][numBIcategory[x]] = 5;
        }
    }
}

void addHUMS(int arr[], int len) {
    LOGI("chickend"); 
    int combinations = pow(len, numBIcategory.size());

    // Resize rs to fit all combinations
    LOGI("chickpea"); 
    int startIndex = rsHUMS.size();
    LOGI("rooster"); 
    rsHUMS.resize(startIndex + combinations, vector<int>(numBIcategory.size() + 1, 0)); // GET THE "can't populate more pages for size class 64" here ////////////////////////////////////////////
    LOGI("bbbbbbb"); 

    // Calculate the minimum and maximum possible sums
    int minSum = numBIcategory.size();
    LOGI("aaaaaaa"); 
    int maxSum = 5 * numBIcategory.size();
    LOGI("work"); 
    double step = static_cast<double>(maxSum - minSum) / 11; // Adjust step to ensure better distribution
    LOGI("chicken");

    for (int k = 0; k < combinations; k++) {
        int sum = 0;
        int temp = k;
        for (int i = 0; i < numBIcategory.size(); i++) {
            rsHUMS[startIndex + k]
              [i] = arr[temp % len];
            sum += rsHUMS[startIndex + k][i];
            temp /= len;
        }
        rsHUMS[startIndex + k][numBIcategory.size()] = sum;  // Storing the sum as the last element

        // Determine the category for the sum
        if (sum <= minSum + 2 * step) { // Larger range for category 1
            rsHUMS[startIndex + k][numBIcategory.size()] = 1;
        } else if (sum <= minSum + 3 * step) {
            rsHUMS[startIndex + k][numBIcategory.size()] = 2;
        } else if (sum <= minSum + 4 * step) {
            rsHUMS[startIndex + k][numBIcategory.size()] = 3;
        } else if (sum <= minSum + 5 * step) {
            rsHUMS[startIndex + k][numBIcategory.size()] = 4;
        } else if (sum <= minSum + 6 * step) {
            rsHUMS[startIndex + k][numBIcategory.size()] = 5;
        } else if (sum <= minSum + 7 * step) {
            rsHUMS[startIndex + k][numBIcategory.size()] = 6;
        } else if (sum <= minSum + 8 * step) {
            rsHUMS[startIndex + k][numBIcategory.size()] = 7;
        } else if (sum <= minSum + 9 * step) {
            rsHUMS[startIndex + k][numBIcategory.size()] = 8;
        } else {
            rsHUMS[startIndex + k][numBIcategory.size()] = 9;
        }
    }
}

void edgeBreak(double Xmin, double Xmax) { // Inputs the Xmin & Xmax values from
                                           // BIints AND the 1x6 array Xbps
  // Determines what breakpoints are contained in a specified interval
  // for a given basic indicator xk.
  // Xbps = [u t T U a eqn]                   //X Break Points
  // Output: [Xmin u m t T M U Xmax]          //Outputs the edge break poitns &
  // the break points
  // double* xeb = new double[8];

  if (Xmin == Xmax) {
    xeb = {Xmin, -1, -1, -1, -1, -1, -1, -1}; // Edge Case
  }
  xeb[0] = Xmin;
  double u = xbps[0];
  double t = xbps[1];
  double T = xbps[2];
  double U = xbps[3];
  double a = xbps[4];
  double M;
  double m; // Initialize the variables

  if (xbps[5] == 1) {
    M = (1 - a) * U + a * T; // Makes the M value
    xeb[1] = -1;
    xeb[2] = -1;
    xeb[3] = -1;
    if (T > Xmin && T < Xmax) {
      xeb[4] = T;
    } else {
      xeb[4] = -1;
    }
    if (M > Xmin && M < Xmax) {
      xeb[5] = M;
    } else {
      xeb[5] = -1;
    }
    if (U > Xmin && U < Xmax) {
      xeb[6] = U;
    } else {
      xeb[6] = -1;
    }
    xeb[7] = Xmax;
  } else if (xbps[5] == 2) {
    m = ((1 - a) * u) + (a * t);
    xeb[4] = -1;
    xeb[5] = -1;
    xeb[6] = -1;
    if (u > Xmin && u < Xmax) {
      xeb[1] = u;
    } else {
      xeb[1] = -1;
    }
    if (m > Xmin && m < Xmax) {
      xeb[2] = m;
    } else {
      xeb[2] = -1;
    }
    if (t > Xmin && t < Xmax) {
      xeb[3] = t;
    } else {
      xeb[3] = -1;
    }
    xeb[7] = Xmax;
  } else {
    M = ((1 - a) * U) + (a * T);
    m = ((1 - a) * u) + (a * t);
    if (u > Xmin && u < Xmax) {
      xeb[1] = u;
    } else {
      xeb[1] = -1;
    }
    if (m > Xmin && m < Xmax) {
      xeb[2] = m;
    } else {
      xeb[2] = -1;
    }
    if (t > Xmin && t < Xmax) {
      xeb[3] = t;
    } else {
      xeb[3] = -1;
    }
    if (T > Xmin && T < Xmax && T != t) {
      xeb[4] = T;
    } else {
      xeb[4] = -1;
    }
    if (M > Xmin && M < Xmax) {
      xeb[5] = M;
    } else {
      xeb[5] = -1;
    }
    if (U > Xmin && U < Xmax) {
      xeb[6] = U;
    } else {
      xeb[6] = -1;
    }
    xeb[7] = Xmax;
  }
}

void level0case1(double X, double T, double U, double a) { //Lower value desired 
  double M = ((1 - a) * U) + (a * T);
  if (X < T) {
    mu0[0] = 0;
  } else if (X >= T && X < M) {
    mu0[0] = 0;
  } else if (X >= M && X <= U) {
    mu0[0] = (1 / (a * (U - T))) * X - (((1 - a) * U + a * T) / (a * (U - T)));
  } else {
    mu0[0] = 1;
  }
  if (X < T) {
    mu0[1] = 0;
  } else if (X >= T && X < M) {
    mu0[1] = (1 / ((1 - a) * (U - T))) * X - (T / ((1 - a) * (U - T)));
  } else if (X >= M && X <= U) {
    mu0[1] = -(1 / (a * (U - T))) * X + (U / (a * (U - T)));
  } else {
    mu0[1] = 0;    
  }
  if (X < T) {
    mu0[2] = 1;
  } else if (X >= T && X < M) {
    mu0[2] = -(1 / ((1 - a) * (U - T))) * X +
       (((1 - a) * U + a * T) / ((1 - a) * (U - T)));
  } else if (X >= M && X <= U) {
    mu0[2] = 0;
  } else {
    mu0[2] = 0;
  }
  if (mu0[0] == 1){
    mu0[1] = 0;
    mu0[2] = 0;
  } else if (mu0[1] == 1){
    mu0[0] = 0;
    mu0[2] = 0;
  } else if (mu0[2] == 1){
    mu0[0] = 0;
    mu0[1] = 0;
  }
}

void level0case2(double X, double t, double u, double a) {
  double m = (1 - a) * u + a * t;

  // Level 0 Weak Membership Grade
  if (X < u) {
    mu0[0] = 1;
  } else if (X >= u && X < m) {
    mu0[0] = -(1 / (a * (t - u))) * X + (((1 - a) * u + a * t) / (a * (t - u)));
  } else if (X >= m && X <= t) {
    mu0[0] = 0;
  } else {
    mu0[0] = 0;
  }

  // Level 0 Medium Membership Grade
  if (X < u) {
    mu0[1] = 0;
  } else if (X >= u && X < m) {
    mu0[1] = (1 / (a * (t - u))) * X - (u / (a * (t - u)));
  } else if (X >= m && X <= t) {
    mu0[1] = -(1 / ((1 - a) * (t - u))) * X + (t / ((1 - a) * (t - u)));
  } else {
    mu0[1] = 0;
  }

  // Level 0 Strong Membership Grade
  if (X < u) {
    mu0[2] = 0;
  } else if (X >= u && X < m) {
    mu0[2] = 0;
  } else if (X >= m && X <= t) {
    mu0[2] = (1 / ((1 - a) * (t - u))) * X -
             (((1 - a) * u + a * t) / ((1 - a) * (t - u)));
  } else {
    mu0[2] = 1;
  }
  if (mu0[0] == 1){
    mu0[1] = 0;
    mu0[2] = 0;
  } else if (mu0[1] == 1){
    mu0[0] = 0;
    mu0[2] = 0;
  } else if (mu0[2] == 1){
    mu0[0] = 0;
    mu0[1] = 0;
  }
}

void level0case3(double X, double t, double u, double T, double U, double a) {
  double m = (1 - a) * u + a * t;
  double M = (1 - a) * U + a * T;

  // Level 0 Case 3 Weak Membership Grade
  if (X < u) {
    mu0[0] = 1;
  } else if (X >= u && X < m) {
    mu0[0] = -(1 / (a * (t - u))) * X + (((1 - a) * u + a * t) / (a * (t - u)));
  } else if (X >= m && X < t) {
    mu0[0] = 0;
  } else if (X >= t && X < T) {
    mu0[0] = 0;
  } else if (X >= T && X < M) {
    mu0[0] = 0;
  } else if (X >= M && X < U) {
    mu0[0] = (1 / (a * (U - T))) * X - (((1 - a) * U + a * T) / (a * (U - T)));
  } else {
    mu0[0] = 1;
  }

  // Level 0 Case 3 Medium Membership Grade
  if (X < u) {
    mu0[1] = 0;
  } else if (X >= u && X < m) {
    mu0[1] = (1 / (a * (t - u))) * X - (u / (a * (t - u)));
  } else if (X >= m && X < t) {
    mu0[1] = -(1 / ((1 - a) * (t - u))) * X + (t / ((1 - a) * (t - u)));
  } else if (X >= t && X < T) {
    mu0[1] = 0;
  } else if (X >= T && X < M) {
    mu0[1] = (1 / ((1 - a) * (U - T))) * X - (T / ((1 - a) * (U - T)));
  } else if (X >= M && X < U) {
    mu0[1] = -(1 / (a * (U - T))) * X + (U / (a * (U - T)));
  } else {
    mu0[1] = 0;
  }

  // Level 0 Case 3 Strong Membership Grade
  if (X < u) {
    mu0[2] = 0;
  } else if (X >= u && X < m) {
    mu0[2] = (0) * X + (0);
  } else if (X >= m && X < t) {
    mu0[2] = (1 / ((1 - a) * (t - u))) * X -
             (((1 - a) * u + a * t) / ((1 - a) * (t - u)));
  } else if (X >= t && X < T) {
    mu0[2] = 1;
  } else if (X >= T && X < M) {
    mu0[2] = -(1 / ((1 - a) * (U - T))) * X +
             (((1 - a) * U + a * T) / ((1 - a) * (U - T)));
  } else if (X >= M && X < U) {
    mu0[2] = 0;
  } else {
    mu0[2] = 0;
  }
  if (mu0[0] == 1){
    mu0[1] = 0;
    mu0[2] = 0;
  } else if (mu0[1] == 1){
    mu0[0] = 0;
    mu0[2] = 0;
  } else if (mu0[2] == 1){
    mu0[0] = 0;
    mu0[1] = 0;
  }
}

double SIcalc(){
  std::vector<std::vector<double>> mu1s(numCategories, std::vector<double>(5, 0.0));
  std::vector<double> mu2s(9, 0.0);
  int numRows = 0; 
  int previousRows = 0; 
  int p = 0;
  for (int i = 0; i < numCategories; i++){
    numRows += pow(3, numBIcategory[i]);
    int numCols = numBIcategory[i] + 1;
    for (int rule = previousRows; rule < numRows; rule++){
      double product = 1;
      for (int j = 0; j < numCols - 1; j++){
        product *= mu0grades[j+p][rs[rule][j]-1];
      }
      mu1s[i][rs[rule][rs[rule].size()-1] -1] += product;
    }
    previousRows = numRows;
    p += numBIcategory[i];
  }

  numRows = rsHUMS.size();
  int numCols = rsHUMS[0].size();

  for (int rule = 0; rule < numRows; ++rule) {
    double product = 1;
    for (int j = 0; j < numCols - 1; ++j) {
      product =
          product * mu1s[j][rsHUMS[rule][j] - 1]; // Adjust for 0-based indexing
    }
    mu2s[(rsHUMS[rule][rsHUMS[0].size() - 1]) - 1] +=
        product; // Adjust for 0-based indexing // Adjust for 0-based indexing
  }
  double SII;
  return SII = 0.000 * mu2s[0] + 0.125 * mu2s[1] + 0.250 * mu2s[2] + //Calculates the final SII value based on [EL VL L FL I FH H VH EH] 
     0.375 * mu2s[3] + 0.500 * mu2s[4] + 0.625 * mu2s[5] +
     0.750 * mu2s[6] + 0.875 * mu2s[7] + 1.000 * mu2s[8];
}

void level0casePicker(){
  for (int i = 0; i < numBI; i++){
    if (BIbreaks[i][5] == 1){
      level0case1(xebs[i][xebsIteration[i]], BIbreaks[i][2], BIbreaks[i][3], BIbreaks[i][4]);
    } else if (BIbreaks[i][5] == 2){
      level0case2(xebs[i][xebsIteration[i]], BIbreaks[i][1], BIbreaks[i][0], BIbreaks[i][4]);
    } else {
      level0case3(xebs[i][xebsIteration[i]], BIbreaks[i][1], BIbreaks[i][0], BIbreaks[i][2], BIbreaks[i][3], BIbreaks[i][4]);
    }
    if (i == 6 && BIints[6][0] == 0){
      mu0 = {1, 0, 0};
    }
    if (i == 3 && BIints[3][1] == 0){
      if (ActualInts[0][1] <= 67.94605032){
        mu0 = {0, 0, 1};
      } else{
        mu0 = {1, 0, 0};
      }
    }

    mu0grades[i] = mu0; 
    SIIvalue = SIcalc();
    if (counter == 1){
    for (int j = 0; j < 3; j++){
      std::cout << mu0grades[i][j] << " ";
    } std::cout << "\n";  
    }
  }
  combosRow.push_back(SIIvalue);
  for (int i = 0; i < numBI; i++){
    combosRow.push_back(xebs[i][xebsIteration[i]]);
  }
  combos.push_back(combosRow);
  combosRow.clear();
}

void nestedLoops(int length){
  if (length == numBI){
    counter++;
   level0casePicker();
  } else {
    length++;
    if (xebs[length-1].size() == 2 && xebs[length-1][0] == xebs[length-1][1]){
      xebsIteration.push_back(0);
      nestedLoops(length);
      xebsIteration.pop_back();
    } else {
      for (int i = 0; i < xebs[length-1].size(); i++){
        xebsIteration.push_back(i);
        nestedLoops(length);
        xebsIteration.pop_back();
      }
    }
  }
}

tuple<string, string> correctInputs(double* array, int arrayLen){
  BIintsConst = "";
  ActualIntsConst ="";

  
  LOGI("PRINTING AFPOIJEOFJAEPAIDPAFFAPOJFAPOEFPE");
  LOGI("%s", BIintsConst.c_str());


  for (int i = 1; i <= 30; i++) {
    BIintsConst += std::to_string(array[i-1]) + " ";
    if(i % 2 == 0){
      BIintsConst += "\n";
    }
  }

  ActualIntsConst += std::to_string(array[30]) + " ";
  ActualIntsConst += std::to_string(array[31]);

  for(int b=33;b<=arrayLen;b++) {
    BIintsConst += std::to_string(array[b-1]) +" ";
    if(b%2==0) {
      BIintsConst +="\n";
    }
  }

  BIlist.push_back(BIintsConst);

  LOGI("PRINTING BINTCONST");
  LOGI("%s", BIintsConst.c_str());

  
  LOGI("PRINTING BILISTBACK");
  LOGI("%s", BIlist.back().c_str());

  return make_tuple(BIintsConst, ActualIntsConst);

  // LOGI("Printing ARRAY");
  // for (int i = 0; i < 32; i++) {
  //     double value = array[i];
  //     std::stringstream ss;
  //     ss << value;
  //     std::string valueString = ss.str();
  //     LOGI("%s", valueString.c_str());
  // }
      // double* value = array;
      // std::stringstream ss;
      // ss << value;
      // std::string valueString = ss.str();
      // LOGI("%s", valueString.c_str());
  // LOGI("Done Printing ARRAY");
  // LOGI("%s", BIintsConst.c_str());

}




extern "C" int real(double* array, int arraySize, double* additionalArr, int additionalArrSize) {
  auto vals = correctInputs(array,arraySize);
  string bival = get<0>(vals);
  string actval = get<1>(vals);
  combos.clear();
  BIbreaks.clear();
  LOGI("PRINTING AAAAAAAAAAAAAAAAAAA[n-1].toString()");
  LOGI("PRINTING additionalArr[n-1].toString()");
  for(int n=0;n<additionalArrSize;n++) {
     if(n%7==0) {
      BIbreaksConst+="\n";
    }
    if(n%7==5 || n%7==6) {
      BIbreaksConst+=std::to_string((int)additionalArr[n]) + " "; //convert double to int
      LOGI("%s",std::to_string((int)additionalArr[n]).c_str());
    }
    else {
    BIbreaksConst+=std::to_string(additionalArr[n]) + " ";
        LOGI("%s", std::to_string(additionalArr[n]).c_str());

    }
    // double apple = 1.0;

  }
  BIints.clear();
  ActualInts.clear();
  variables.clear();
  xebs.clear();
  newXebs.clear();
  mu0grades.clear();
  mu1s.clear();
  combosRow.clear();
  xebsIteration.clear();
  rs.clear();
  LOGI("real values");
  LOGI("%s", bival.c_str());

  std::stringstream myfile1(BIbreaksConst);
  std::stringstream myfile2(bival);
  std::stringstream myfile3(actval);
//   ifstream myfile1("cpp\\src\\ActualInts.txt");
//   ifstream myfile2("cpp\\src\\BIints.txt");
//   ifstream myfile3("cpp\\src\\ActualInts.txt");

    // if (!myfile1.is_open() || !myfile2.is_open()) {
    //   cerr << "Failed to open one of the files." << endl;
    //   return 1;
    // }

    double value;
    vector<double> row;
    vector<double> categories;     
    // Read data from BIbreaks.txt

  LOGI("TESTINGGGGGGGGGGGGGGGGGGGGG");
  LOGI("PRINTING BIBREAKSCONST IN FOR LOOP");
    while (myfile1 >> value) {
      row.push_back(value);
        
      LOGI("%s", std::to_string(value).c_str());
      if (row.size() == 7) {
        categories.push_back(row[6]);
        row.pop_back();

        BIbreaks.push_back(row);
        row.clear(); // Clear row for next iteration
      }
    }

    // myfile1.close(); 

  while (myfile3 >> value) {
    row.push_back(value);

    if (row.size() == 2) {
      ActualInts.push_back(row);
      row.clear(); 
    }
  }

//   myfile3.close();

    // Read data from BIints.txt
    while (myfile2 >> value) {
      row.push_back(value);

      // Check for end of row (assuming 6 columns per row)
      if (row.size() == 2) {
        BIints.push_back(row);
        row.clear(); // Clear row for next iteration
      }
    }


//   myfile2.close();
  LOGI("######################TESTINGG");
  increaseRuntime();

  double companyFreshwater = (ActualInts[0][0] + ActualInts[0][1]) / 2;
  double reductionFreshwater;
  if (companyFreshwater == 0){
    reductionFreshwater = 0;
  } else {
    reductionFreshwater =
    100 * (1 - pow(67.94605032 / companyFreshwater, 0.04));
  }
  if (reductionFreshwater < 0) {
    reductionFreshwater = 0;
  }
  double reductionGHG;
  double companyGHG = (BIints[4][0] + BIints[4][1])/2;
  if (companyGHG == 0) {
    reductionGHG = 0;
  }
  else {
    reductionGHG = 100 * (1 - pow(514.2857143 / companyGHG, 0.05));
    if (reductionGHG < 0) {
      reductionGHG = 0;
    }
  }

  LOGI("HIHIIHIHIHIHIHIHIETSTNIG");
  //LOGI("PRINTING BINTCONST");
  //LOGI("%s", BIbreaksConst.c_str());

  LOGI("EFE");
  BIbreaks[3][1] = reductionFreshwater;
  LOGI("EFE");
  BIbreaks[6][1] = reductionGHG;
  LOGI("testing 0");
  for (int i = 0; i < BIbreaks.size(); i++) {
    LOGI("%s", std::to_string(i).c_str());
    xbps = BIbreaks[i];
    LOGI("%s", std::to_string(BIints[i][0]).c_str());
    edgeBreak(BIints[i][0], BIints[i][1]); //breaks here on i = 15
    newXebs.push_back(xeb);
  }
  LOGI("TESTING 1");
  for (int i = 0; i < categories.size(); i++){
    if (numCategories < categories[i]){
      numCategories = categories[i];
    }
  }
  int val = 0;
  int iteration = 0; // Move iteration outside the loop
  LOGI("TESTING 2");
  for (int i = 0; i < numCategories; i++) {
      int category = 0;
      if (val < numCategories) { // Adjust the condition to allow correct increments
          val++;
          while (iteration < categories.size() && val == categories[iteration]) {
              category++;
              iteration++;
          }
          numBIcategory.push_back(category);
      }
  }
  LOGI("afwefawefawefwaef");
  for (int i = 0; i < newXebs.size(); i++) {
    std::vector<double> newRow;
    for (int j = 0; j < 8; j++) {
      if (!(newXebs[i][j] == -1)) {
        newRow.push_back(newXebs[i][j]);
      }
    }
    xebs.push_back(newRow);
  }
    LOGI("homixidehomixidehomixide");

  numBI = BIbreaks.size();
  for (int i = 0; i < numBI; i++){
    mu0grades.push_back(mu0);
  }

  LOGI("watermelon");
  int arr[] = {1, 2, 3}; 
  int len = sizeof(arr) / sizeof(arr[0]);
  for (int x = 0; x < numBIcategory.size(); x++) {
    addSums(arr, len, x);
  }
  LOGI("cantalope");
  int level1[] = {1, 2, 3, 4, 5}; 
  LOGI("dragonfruit");
  len = sizeof(level1) / sizeof(level1[0]);
  LOGI("grape");
  addHUMS(level1, len);
  LOGI("pear");
  vector<int> counts(9, 0);
  LOGI("honeydew");
  nestedLoops(0); //////////// THIS TAKES QUITE A LONG TIME TO RUN TOO ////////////////////////////
  LOGI("banana");
  std::sort(combos.begin(), combos.end(),
    [](const std::vector<double> &a, const std::vector<double> &b) {
      return a[0] < b[0];
    });
  std::cout << "SII Min Value: " << combos[0][0] << "\nMin BI Permutations: ";
  LOGI("ftjftjyftjfnndrcbngfdcr");
  for (int i = 1; i < combos[0].size(); i++){
    std::cout << "BI " << i << ": " << combos[0][i] << "   ";
  }
  std::cout << "\n\nSII Max Value: " << combos[combos.size()-1][0] << "\nMax BI Permutations: ";
  for (int i = 1; i < combos[combos.size()-1].size(); i++){
    std::cout << "BI " << i << ": " << combos[combos.size()-1][i] << "   ";

  }
  std::cout << "\n\n\n";
  for (int i = 0; i < numBIcategory.size(); i++){
    std::cout << "Number of BI in Category " << i+1 << ": " <<  numBIcategory[i] << "\n"; 
  }
  std::cout << "\nNumber of Branches: " << combos.size() << " ";

LOGI("FINALLLL ENDDDDD");

 return 1;


}



extern "C" const char* getBIintsConst(){
  static string store = BIlist.back(); 
  return store.c_str();
}

extern "C" const  char* getActualIntsConst(){
  static string store = ActualIntsConst; 
  return store.c_str();
}


extern "C" double getMin() {
  // LOGI("AAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBB");
  // LOGI("PRINTING BIINTS");
  //  for (int i = 0; i < BIints.size(); i++) {
  //    for (int j = 0; j < BIints[i].size(); j++){
  //      double value = BIints[i][j];
  //      std::stringstream ss;
  //      ss << value;
  //      std::string valueString = ss.str();
  //      LOGI("%s", valueString.c_str());
  //    }
  //    LOGI("Goodbye");
  //  }
  // LOGI("Printing COMBOS");
  // for (int i = 0; i < combos.size(); i++) {
  //     double value = combos[i][0];
  //     std::stringstream ss;
  //     ss << value;
  //     std::string valueString = ss.str();
  //     LOGI("%s", valueString.c_str());
  // }
  
  // LOGI("All 0th values of combos have been printed");
  return combos[0][0];
}



extern "C" double getMax() {
  // LOGI ("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
//   for (int i = 0; i < combos.size(); i++) {
//     for (int j = 0; j < combos[i].size(); j++){
//       double value = combos[i][j];
//       std::stringstream ss;
//       ss << value;
//       std::string valueString = ss.str();
// //     LOGI("Calculation result: %s", result_str);
//       LOGI("%s", valueString.c_str());
//     }
//     LOGI("Goodbye");
//   }
// BIints.clear();
// ActualInts.clear();
  return combos[combos.size()-1][0];
}
