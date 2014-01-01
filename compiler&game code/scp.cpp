#include <cstdio>
#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <map>
using namespace std;

map <string, int> var, var_l;
int address;
int empty;

void Read_init() {
	string str;
	int x;
	
	while (cin >> str) {
		if (str == "end") break;
		cin >> x;
		var[str] = address;
		var_l[str] = x;
		address +=x;
	}
}

int C(string str) {
	if (str[0] == '#') {
		if ('A'<=str[1] && str[1] <= 'Z') return str[1] - 'A' +1;
		if ('0'<=str[1] && str[1] <= '9') return str[1];
		if (str[1] == 'r') return 27;
		if (str[1] == 'g') return 28;
		if (str[1] == 'b') return 29;
		if (str[1] == 'w') return 30;
	}
	if (str[0] == '_') return atoi(str.substr(1).c_str());
	if (str[0] <= '9' && str[0] >= '0') return atoi(str.c_str());
	return var[str];
}

void Read_prob() {
	cout << "label_program" << endl;
	string str, v1, v2;
	while (cin >> str) {
		if (str.substr(0, 5) == "label")
			cout << str << endl;
		else if (str == "read"  || str == "write" || str == "gpu") {
			cout << "label_empty" << endl;
			cin >> v1 >> v2;
			cout << str << ' ' << C(v1) << ' ' << C(v2) << endl;
			cout << "label_empty" << endl;
		} else if (str.substr(0, 4) == "jump") {
			cin >> v1;
			cout << "rl 7 " << v1 << endl;
			cout << "rh 7 " << v1 << endl;
			if (str == "jumpif") {
				cin >> v2;
				cout << str << " 7 " << C(v2) << endl;
			} else cout << str << " 7\n";
		} else {
			if (str[0] != '!') {
				cin >> v1 >> v2;
			} else cin >> v1;
			
			if (str == "!")
				cout << "not " << C(v1) << endl;
			else if (v1 == "+=")
				cout << "add " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == "-=")
				cout << "sub " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == "*=")
				cout << "mul " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == "^=")
				cout << "xor " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == "&=")
				cout << "and " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == "|=")
				cout << "or " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == ">>=")
				cout << "shr " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == "<<=")
				cout << "shl " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == "<")
				cout << "sml " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == ">")
				cout << "grt " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == "==")
				cout << "eq " << C(str) << ' ' << C(v2) << endl;
			else if (v1 == "=") {
				if (v2[0] == '_') 
					cout << "cpy " << C(str) << ' ' << C(v2) << endl;
				else {
					cout << "rl " << C(str) << ' ' << C(v2) << endl;
					cout << "rh " << C(str) <<  ' ' << C(v2) << endl;
				}
			}
		}
	}
}

int main() {
	Read_init();
	Read_prob();

	return 0;
}