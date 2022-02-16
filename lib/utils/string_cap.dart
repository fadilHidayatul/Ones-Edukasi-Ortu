// ${allbayar[index].tipesemester![0].toUpperCase()}${ allbayar[index].tipesemester!.substring(1).toLowerCase() }

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}