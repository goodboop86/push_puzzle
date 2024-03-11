class Company {
  int discussion = 0;
  late Company company;

  void accept(Visitor visitor) {
    company = Company();
    if(discussion < 5){
      discussion +=1;
      visitor.quota += 10;
      visitor.visit(this);
    }
  }
  Company();
}

class Visitor {
  int quota = 0;

  void visit(Company company) {
    company.accept(this);
  }
  Visitor();
}

void main() {
  Company company = Company();
  Visitor visitor = Visitor();
  visitor.visit(company);

  print(visitor.quota);

}