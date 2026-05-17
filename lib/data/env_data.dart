import 'package:portfolio/data/portfolio_data.dart';

class EnvVariable {
  final String key;
  final String value;

  const EnvVariable(this.key, this.value);
}

class EnvData {
  EnvData._();

  static const List<EnvVariable> all = [
    EnvVariable('DEVELOPER', 'Tiaan_Bothma'),
    EnvVariable('ROLE', 'Flutter_Full_Stack_Developer'),
    EnvVariable('UNIVERSITY', 'North-West_University'),
    EnvVariable('DEGREE', 'BSc_Information_Technology'),
    EnvVariable('EXPERIENCE', '3+_Years'),
    EnvVariable('CORE_STACK', 'Flutter_Dart_Firebase_Docker'),
    EnvVariable('SECONDARY_STACK', 'Python_Linux_SQL_Git'),
    EnvVariable('LOCATION', 'South_Africa'),
    EnvVariable('REMOTE', 'Available'),
    EnvVariable('STATUS', 'Student+Professional'),
    EnvVariable('EMPLOYER', '18INK_Productions'),
    EnvVariable('FREELANCE', 'Fiverr'),
    EnvVariable('GITHUB', 'github.com/TiaanBothma'),
    EnvVariable('LINKEDIN', 'linkedin.com/in/tiaan-bothma'),
    EnvVariable('OS', 'Tiaan_Bothma_OS_${PortfolioData.version}'),
  ];

  static String asText() {
    return all.map((env) => '${env.key}=${env.value}').join('\n');
  }
}
