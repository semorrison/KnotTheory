import java.io.Serializable;

public class SmoothingColumn implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = -4287954448286736780L;
	int n;
    Cap smoothings[];
    int numbers[];

    public SmoothingColumn(int n) {
	this.n = n;
	smoothings = new Cap[n];
	numbers = new int[n];
    }

    public boolean equals(Object o) {
	if (!(o instanceof SmoothingColumn))
	    return false;
	SmoothingColumn sc = (SmoothingColumn) o;
	if (n != sc.n)
	    return false;
	if (!java.util.Arrays.equals(smoothings, sc.smoothings))
	    return false;
	if (!java.util.Arrays.equals(numbers, sc.numbers))
	    return false;
	return true;
    }

    public void printNumbers() {
	for (int i = 0; i < n; i++)
	    System.out.print(" " + numbers[i]);
	System.out.println();
    }
}
