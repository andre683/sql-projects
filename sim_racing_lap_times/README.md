
# Sim Racing Telemetry Data Transformation Project

This project involves analyzing **Assetto Corsa Competizione** (sim racing) data recorded with **Sim Racing Telemetry** by UNAmedia. The exported CSV data provides a great opportunity to practice data transformations using SQL.

## Project Overview

The core of this project is a SQL script designed to mirror the lap time table from the exported telemetry data. The documentation provided by UNAmedia (link below) was instrumental in understanding the various fields and their formats.

- [Sim Racing Telemetry Documentation](https://lnkd.in/e_j3E2xq)

## SQL Functions Used

The following SQL functions were utilized in the script to achieve specific data transformations:

- **CASE**: Indicate valid or invalid laps.
- **CONCAT**: Format and combine lap time components.
- **LPAD**: Ensure time components have leading zeros.
- **CAST**: Convert values to strings for concatenation.
- **FLOOR**: Calculate whole minutes and seconds from lap time.
- **ROUND**: Round milliseconds to the nearest whole number.

## Future Improvements

As a next step, I plan to expand the analysis to compare different lap sectors. Since sector data is not available in the initial export, I will explore methods to split the track into sectors for further comparisons.
