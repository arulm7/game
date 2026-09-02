enum CellStatus {
  open, // [ ] Available pathway
  blocked, // [X] Blocked/clogged pathway
  critical, // [!] Critical pressure point
  cleared, // Successfully purified by card effect
}

class GridCell {
  final int row;
  final int col;
  final CellStatus status;
  final String label;

  const GridCell({
    required this.row,
    required this.col,
    required this.status,
    required this.label,
  });

  GridCell copyWith({
    int? row,
    int? col,
    CellStatus? status,
    String? label,
  }) {
    return GridCell(
      row: row ?? this.row,
      col: col ?? this.col,
      status: status ?? this.status,
      label: label ?? this.label,
    );
  }

  static List<GridCell> get initialBreachGrid => const [
        // Row 0: [ ] [X] [X]
        GridCell(row: 0, col: 0, status: CellStatus.open, label: 'L-Superior'),
        GridCell(row: 0, col: 1, status: CellStatus.blocked, label: 'Aortic Arch'),
        GridCell(row: 0, col: 2, status: CellStatus.blocked, label: 'R-Coronary'),

        // Row 1: [ ] [!] [ ]
        GridCell(row: 1, col: 0, status: CellStatus.open, label: 'Pulm-Trunk'),
        GridCell(row: 1, col: 1, status: CellStatus.critical, label: 'Septal Root'),
        GridCell(row: 1, col: 2, status: CellStatus.open, label: 'Circumflex'),

        // Row 2: [ ] [ ] [ ]
        GridCell(row: 2, col: 0, status: CellStatus.open, label: 'Apex Tendril'),
        GridCell(row: 2, col: 1, status: CellStatus.open, label: 'Marginal Bed'),
        GridCell(row: 2, col: 2, status: CellStatus.open, label: 'Micro-Vessel'),
      ];
}
