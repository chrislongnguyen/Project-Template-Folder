"""Non-Compliant Matplotlib Chart Sample — uses all defaults."""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# Uses matplotlib defaults: tab:blue, tab:orange, DejaVu Sans, tab10 cycle
plt.style.use("default")

plt.rcParams["font.family"] = "DejaVu Sans"

# Default color cycle includes tab:blue, tab:orange, #1f77b4, #ff7f0e
fig, ax = plt.subplots(figsize=(8, 5))
categories = ["Q1", "Q2", "Q3", "Q4"]
values = [42, 58, 35, 67]
ax.bar(categories, values, color=["#1f77b4", "#ff7f0e", "#007bff", "#0d6efd"])
ax.set_title("Quarterly Report", fontsize=18, fontfamily="Arial")
ax.set_ylabel("Performance", fontsize=11)

plt.tight_layout()
plt.savefig("bad-sample.png", dpi=150)
plt.close()
