# How to contribute to Document

## Report a bug

- Please check [issues](https://github.com/DougHennig/Document/issues) if the bug has already been reported.

- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## Fix a bug or add an enhancement

- Fork the project: see this [guide](https://www.dataschool.io/how-to-contribute-on-github/) for setting up and using a fork.

- Make whatever changes are necessary.

- If you make changes to the Document class, change the cVersion property to reflect the current date, such as "2025.04.06" for April 6, 2025.

- If you make changes to the source for Document.dll, change the assembly version number to reflect the current date, such as "2025.04.06" for April 6, 2025.

- Describe the changes at the top of *ChangeLog.md*.

- Run BuildZip.prg in the BuildProcess folder to create FoxGet\source.zip (the file used by [FoxGet](https://github.com/DougHennig/FoxGet) to install Document).

- Commit the changes.

- Push to your fork.

- Create a pull request; ensure the description clearly describes the problem and solution or the enhancement.

----
Last changed: 2025-07-29