#include <bits/stdc++.h>
using namespace std;
typedef struct{
int index;
float v;
}Item;
bool comp(Item i1, Item i2){return(i1.v>i2.v);}
void knapsack(int n,float m,float * w, float * p, float*&x){
Item*I;
I=new Item[n];
for(int i=0;i<n;i++)
{
I[i].index=i;I[i].v=p[i]/w[i];
}
sort(I,I+n,comp);
for(int i=0;i<n;i++)x[i]=0;
int i;
for(i=0;i<n;i++)
{
if(w[I[i].index]>m)break;
x[I[i].index]=1.0;m=m-w[I[i].index];
}
if(i<=n)x[I[i].index]=m/(w[I[i].index]);
}
int main() {
int n;
float m,*w,*p,*x;
float sum=0;
string *names;
cin>>n>>m;
w=new float[n];
p=new float[n];
x=new float[n];
names=new string[n];
for(int i=0;i<n;i++)cin>>names[i]>>w[i]>>p[i];
knapsack(n,m,w, p, x);
cout<<"Output: \n";
for(int i=0;i<n;i++){cout<<names[i]<<": "<<x[i]<<endl;sum+=x[i]*p[i];}
cout<<"Net profit= "<<0.5*sum<<endl;
return 0;
}