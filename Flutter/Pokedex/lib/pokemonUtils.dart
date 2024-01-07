import 'dart:ui';

class PokemonUtils {

  static Color getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'planta':
        return const Color(0xff9DD091);
      case 'fuego':
        return const Color(0xffFFBF7F);
      case 'eléctrico':
        return const Color(0xffFCDF7F);
      case 'acero':
        return const Color(0xffAFD0DB);
      case 'roca':
        return const Color(0xffD7D4C0);
      case 'agua':
        return const Color(0xff91BFF7);
      case 'bicho':
        return const Color(0xffC8D088);
      case 'dragón':
        return const Color(0xffA6AFF0);
      case 'fantasma':
        return const Color(0xffB79EB7);
      case 'hada':
        return const Color(0xffF6B7F7);
      case 'hielo':
        return const Color(0xff9DEBFF);
      case 'lucha':
        return const Color(0xffEAA087);
      case 'normal':
        return const Color(0xffCFCFCF);
      case 'psíquico':
        return const Color(0xffF69EBC);
      case 'siniestro':
        return const Color(0xffA69E9D);
      case 'tierra':
        return const Color(0xffC8A78C);
      case 'volador':
        return const Color(0xffC0DCF7);
      case 'veneno':
        return const Color(0xffC89EE5);
      default:
        return const Color(0xfffffbff);
    }
  }

  static Color getColorByTypeButton(String type) {
    switch (type.toLowerCase()) {
      case 'planta':
        return const Color(0xff3DA224);
      case 'fuego':
        return const Color(0xffFF8100);
      case 'eléctrico':
        return const Color(0xffFAC100);
      case 'acero':
        return const Color(0xff60A2B9);
      case 'roca':
        return const Color(0xffB0AB82);
      case 'agua':
        return const Color(0xff2481F0);
      case 'bicho':
        return const Color(0xff92A212);
      case 'dragón':
        return const Color(0xff4F60E2);
      case 'fantasma':
        return const Color(0xff713F71);
      case 'hada':
        return const Color(0xffEF71F0);
      case 'hielo':
        return const Color(0xff3DD9FF);
      case 'lucha':
        return const Color(0xffD4400F);
      case 'normal':
        return const Color(0xffA0A2A0);
      case 'psíquico':
        return const Color(0xffEF3F7A);
      case 'siniestro':
        return const Color(0xff4F3F3D);
      case 'tierra':
        return const Color(0xff92501B);
      case 'volador':
        return const Color(0xff82BAF0);
      case 'veneno':
        return const Color(0xff923FCC);
      default:
        return const Color(0xfffffbff);
    }
  }

  static String getSvgIconType(String type) {
    switch (type.toLowerCase()) {
      case 'planta':
        return 'lib/assets/icon/grass.svg';
      case 'fuego':
        return 'lib/assets/icon/fire.svg';
      case 'eléctrico':
        return 'lib/assets/icon/electric.svg';
      case 'acero':
        return 'lib/assets/icon/steel.svg';
      case 'roca':
        return 'lib/assets/icon/rock.svg';
      case 'agua':
        return 'lib/assets/icon/water.svg';
      case 'bicho':
        return 'lib/assets/icon/bug.svg';
      case 'dragón':
        return 'lib/assets/icon/dragon.svg';
      case 'fantasma':
        return 'lib/assets/icon/ghost.svg';
      case 'hada':
        return 'lib/assets/icon/fairy.svg';
      case 'hielo':
        return 'lib/assets/icon/ice.svg';
      case 'lucha':
        return 'lib/assets/icon/fighting.svg';
      case 'normal':
        return 'lib/assets/icon/grass.svg';
      case 'psíquico':
        return 'lib/assets/icon/psychic.svg';
      case 'siniestro':
        return 'lib/assets/icon/dark.svg';
      case 'tierra':
        return 'lib/assets/icon/ground.svg';
      case 'volador':
        return 'lib/assets/icon/flying.svg';
      case 'veneno':
        return 'lib/assets/icon/poison.svg';
      default:
        return '';
    }
  }
}