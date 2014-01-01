#include <cstdio>
#include <iostream>
#include <sstream>
#include <cstdlib>
#include <string>
#include <map>
using namespace std;

map <string, int> var, v_type;
int varAddress = 0;

string GetAddress(string str) {
	
	if (str.find('[')<0)
		return "rl 4 "+var[str]+"\nrh 4 "+var[str]+"\n"
	else if (str.find('[', str.find('[') +1) < 0) {
		for (int i=0; i<str.size(); ++i)
			if (str[i] == ']' || str[i] == '[') str[i] = ' ';
		istringstream sin(str);
		
		string s, u, res= "";
		sin >> s >> u;
		
		if ( u[0]>='0' || u[0] <= '9') {
			res += "rl 4 " + u +"\nrh 4 " + u +"\n";
		} else {
			res += "rl 5 "+ var[u]+"\nrh 5 "+ var[u]+"\n";
			res += "read 4 5\n";
		}
		res += "rl 5 "+ var[s]+"\nrh 5 "+ var[s]+"\n";
		res += "add 4 5\n";
		
		return res;
	} else {
		for (int i=0; i<str.size(); ++i)
			if (str[i] == ']' || str[i] == '[') str[i] = ' ';
		istringstream sin(str);
		
		string s, u, v, res= "";
		sin >> s >> u >> v;
		
		if ( u[0]>='0' || u[0] <= '9') {
			res += "rl 4 " + u +"\nrh 4 " + u +"\n";
		} else {
			res += "rl 5 "+ var[u]+"\nrh 5 "+ var[u]+"\n";
			res += "read 4 5\n";
		}
		
		res += "rl 5 "+ v_type[u]+"\nrh 5 "+ v_type[u]+"\n";
		res += "mul 4 5\n";
		
		if ( u[0]>='0' || u[0] <= '9') {
			res += "rl 4 " + u +"\nrh 4 " + u +"\n";
		} else {
			res += "rl 5 "+ var[u]+"\nrh 5 "+ var[u]+"\n";
			res += "read 4 5\n";
		}
	}
}

string GetLabel() {
	static int cnt = 0;
	++cnt;
	
	string res = "";
	for (int i=cnt; i>0; i /= 10)
		res = char(i %10 +'0') + res;
	
	return "label_"+res;
}


inline void ReadVar() {
	string str;
	while (cin >> str) {
		if (str == "end") break;
		
		char ch;
		do {
			cin >> ch;
		}	while (ch == ' ' || ch == '\t');
		if (ch < ' ') { // a var
			var[str] = varAddress++; ////// give a address
			v_type[str] = -1;
		} else {
			int x;
			cin >> x;
			do {
				cin >> ch;
			}	while (ch == ' ' || ch == '\t');
			
			if (ch < ' ') { // a vector
				var[str] = varAddress; ////// give a address
				varAddress += x;
				v_type[str] = 0;
			} else { // a vector x vector
				int y;
				cin >> y;
				var[str] = varAddress;
				varAddress += x * y;
				
				v_type[str] = y;
			}
		}
	}
}

string ReadPro() {
	string res = "", str;
	

	while (cin >> str) {
		if (str == "end") {
			return res + "\n";
		}
		
		if (str == "if") {
			string if_label = GetLabel();
			string then_label = GetLabel();
			string else_label = GetLabel();
		
			res += ReadPro();
			cin >> str;
			if (str != "then") exit(-1);
			
			res += "rl 7 " + then_label + "\n";
			res += "rh 7 " + then_label + "\n";
			res += "jumpif 7 6\n";
			res += else_label + "\n";
			
			string tmp = ReadPro();
			
			cin >> str;
			if (str != "else") exit(-1);
			
			res += ReadPro();
			
			res += "rl 7 " + if_label + "\n";
			res += "rh 7 " + if_label + "\n";
			res += "jump 7\n";
			res += then_label + "\n";
			
			res += tmp;
			
			res += if_label + "\n";
		} else if (str == "while") {
			string while_label = GetLabel();
			string end_label = GetLabel();
			
			res += while_label;
			
			res += ReadPro();
			
			cin >> str;
			if (str != "begin") exit(-1);
			
			res += "not 6";
			res += "rl 7 " + end_label + "\n";
			res += "rh 7 " + end_label + "\n";
			res += "jumpif 7 6\n";
			
			res += ReadPro();
			
			res += "rl 7 " + while_label + "\n";
			res += "rh 7 " + while_label + "\n";
			res += "jump 7";
			res += end_label + "\n";
		} else {
			int r1=-1, r2=-1;
			string op, str2;
			cin >> op;
			
			if (op != "!") {
				cin >> str2;
				r2 = 3;
				res += GetAddress(str2);
				res += "read 3 4\n";    
			}
			
			if (str[0] != '_') {
				r1 = 2;
				//res += "rl 4 " + GetAddress(str) + "\n";
				//res += "rh 4 " + GetAddress(str) + "\n";
				res += GetAddress(str);
				res += "read 2 4\n";
			}
			
			if (op == ">")
				res += "grt 3 2\n";
			else if (op == "<") 
				res += "sml 3 2\n";
		}
	}
}


int main() {

	ReadVar();
	ReadPro();
	
	return 0;
}
