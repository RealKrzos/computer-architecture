import java.util.Scanner;

public class Main {
    private static int[] RAM = new int[4096];
    private static int row;
    private static int col;

    private static final String prompt1 = "Set array rows: ";
    private static final String prompt2 = "Set array columns: ";
    private static final String prompt3 = "\nChoose action. Read (0) / Write (1)";
    private static final String prompt4 = "Row: ";
    private static final String prompt5 = "Column: ";
    private static final String prompt6 = "Err. Must be 0 or 1.";

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Asking for columns and rows
        System.out.print(prompt1);
        row = scanner.nextInt();

        System.out.print(prompt2);
        col = scanner.nextInt();

        // Calculations for the address array
        int[] addressArray = new int[row * col];
        fillArray(addressArray);

        // Asking for action
        int action;
        do {
            System.out.println(prompt3);
            action = scanner.nextInt();
            if (action == 0) {
                readValue(addressArray);
            } else if (action == 1) {
                writeValue(addressArray);
            } else {
                System.out.println(prompt6);
            }
        } while (true);
    }

    private static void readValue(int[] addressArray) {
        Scanner scanner = new Scanner(System.in);

        System.out.print(prompt4);
        int rowIdx = scanner.nextInt();

        System.out.print(prompt5);
        int colIdx = scanner.nextInt();

        int index = rowIdx * col + colIdx;
        int value = addressArray[index];
        System.out.println(value);
    }

    private static void writeValue(int[] addressArray) {
        Scanner scanner = new Scanner(System.in);

        System.out.print(prompt4);
        int rowIdx = scanner.nextInt();

        System.out.print(prompt5);
        int colIdx = scanner.nextInt();

        System.out.print(prompt5);
        int value = scanner.nextInt();

        int index = rowIdx * col + colIdx;
        addressArray[index] = value;
    }

    private static void fillArray(int[] addressArray) {
        int i = 0;
        int j = 0;
        for (int value = 0; value < addressArray.length; value++) {
            addressArray[value] = i * 100 + (j + 1);
            j++;

            if (j >= col) {
                j = 0;
                i++;
            }
        }
    }
}