import 'dart:io';
import 'dart:math' as math;

///converts the angles from degrees to radians
double torad(double a){
return (a*math.pi)/180;
}

///converts the angles from radius to degrees
double todeg(double a){
  return (a*180)/math.pi;
}

///calculate the first subchord
double firstsubchord(double a, int b){
  // a is the chainage of T1
  //b is the standard subchord
  double c=a/b;
  int d=c.floor();
  int e=d*b;
  if(e<a){
    return (e+b)-a;
  }
  else{
    return e-a;
  }
}

/// calculate the last subchord
double lastsubchord(double a, int b){
  //a is the chainage of T2
  //b is the standard subchord
  double c=a/b;
  int d=c.floor();
  int e=d*b;
  if (e<a){
    return a-e;
  }
  else{
    int wh_before=e-b;
    double lst_chord=a-wh_before;
    return lst_chord;
  }
}

/// to get the angles to degrees, minutes and seconds
String toDMS(double a){
  var deg='\u00B0';
  int b=a.floor();
  double c=a-b;
  c=c*60;
  int d=c.floor();
  double e=c-d;
  e=e*60;
  int f=e.round();
  String angle="${b}${deg} ${d}\' ${f}\"";
  return angle;
}

double decdeg(int a, int b, int c){
  double d=c/60;
  double e=d+b;
  double f=e/60;
  double g=a+f;
  return g;
}

double clpc(num chord,double radius){
  double angle=2*todeg(math.asin((0.5*chord)/radius));
  double c_dist=(angle/360)*2*math.pi*radius;
  return c_dist;
}

int main(){
  print("Chainage of Intersection::\t");
  double? i_chainage=double.parse(stdin.readLineSync()!);
  print("Radius::\t");
  double? radius=double.parse(stdin.readLineSync()!);
  print("Deflection angle (degrees part)::\t");
  int? deg=int.parse(stdin.readLineSync()!);
  print("Deflection angle (minutes part)::\t");
  int? min=int.parse(stdin.readLineSync()!);
  print("Deflection angle (seconds part)::\t");
  int? sec=int.parse(stdin.readLineSync()!);
  double d_angle=decdeg(deg,min,sec);
  print("Standard chord length::\t");
  int? s_chord=int.parse(stdin.readLineSync()!);

//convert the angle to radians
  d_angle=torad(d_angle);

  double t_length=radius*math.tan(d_angle/2); //tangent length
  double T1=i_chainage-t_length;//the backtangent
  double c_length=(todeg(d_angle)/360)*2*math.pi*radius;//the curve length
  double m_chord=2*radius*math.sin(d_angle/2);// the main chord
  double T2=T1+c_length;
  double f_chord= firstsubchord(T1,s_chord);
  double l_chord=lastsubchord(T2,s_chord);

  double cf_chord=clpc(f_chord,radius);
  double cl_chord=clpc(l_chord,radius);
  double cs_chord=clpc(s_chord,radius);

  double pegs=(c_length-(cf_chord+cl_chord))/cs_chord;
  int peg=pegs.floor()+1;
  
  var angles=<double>[];
  angles.add(todeg(math.asin((0.5*f_chord)/radius)));
  double s_angles=todeg(math.asin((0.5*s_chord)/radius));
  for(var i=1;i<=peg;i++){
    angles.add(angles.last+s_angles);
  }

  angles.add(angles.last+todeg(math.asin((0.5*l_chord)/radius)));
  // FIRST OUTPUT
  print("\n\n===============CURVE PROPERTIES============");
  print("Curve length::\t\t${c_length.toStringAsFixed(3)}");
  print("Back tangent::\t\t${T1.toStringAsFixed(3)}");
  print("Forward tangent::\t${T2.toStringAsFixed(3)}");
  print("Main Chord::\t\t${m_chord.toStringAsFixed(3)}");
  print("first subchord::\t${f_chord.toStringAsFixed(3)}");
  print("last subchord::\t\t${l_chord.toStringAsFixed(3)}");
  print("No of pegs::\t\t${peg+2}");

  print("\n\n----------------------------------------------");
  print("PEG\tDEFLECTION ANGLES");
  print("----------------------------------------------");
  angles.forEach((element) { 
    print("${angles.indexOf(element)+1}\t${toDMS(element)}");
  }); 
  return 0;
}