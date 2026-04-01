"""LTC Brand-Compliant Matplotlib Chart Sample."""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib import font_manager

# LTC Brand Colors — source: rules/brand-identity.md
LTC_MIDNIGHT_GREEN = "#004851"
LTC_GOLD = "#F2C75C"
LTC_RUBY_RED = "#9B1842"
LTC_GREEN = "#69994D"
LTC_DARK_PURPLE = "#653469"
LTC_DARK_GUNMETAL = "#1D1F2A"
LTC_WHITE = "#FFFFFF"

# Typography: Inter (English), Work Sans (Vietnamese)
# Register fonts if available locally; Google Fonts used in web output
plt.rcParams["font.family"] = "Inter"
plt.rcParams["font.sans-serif"] = ["Inter", "Work Sans", "sans-serif"]
plt.rcParams["axes.prop_cycle"] = plt.cycler(color=[
    LTC_MIDNIGHT_GREEN, LTC_GOLD, LTC_RUBY_RED, LTC_GREEN, LTC_DARK_PURPLE
])
plt.rcParams["axes.facecolor"] = LTC_WHITE
plt.rcParams["figure.facecolor"] = LTC_WHITE
plt.rcParams["text.color"] = LTC_DARK_GUNMETAL
plt.rcParams["axes.edgecolor"] = LTC_DARK_GUNMETAL
plt.rcParams["axes.labelcolor"] = LTC_DARK_GUNMETAL

# Sample chart
fig, ax = plt.subplots(figsize=(8, 5))
categories = ["Q1", "Q2", "Q3", "Q4"]
values = [42, 58, 35, 67]
ax.bar(categories, values, color=[LTC_MIDNIGHT_GREEN, LTC_GOLD, LTC_RUBY_RED, LTC_GREEN])
ax.set_title("LT Capital Partners — Quarterly Report", fontsize=18, color=LTC_MIDNIGHT_GREEN)
ax.set_ylabel("Performance", fontsize=11)

plt.tight_layout()
plt.savefig("good-sample.png", dpi=150)
plt.close()
