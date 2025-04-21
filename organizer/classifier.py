
from .config import DEFAULT_CATEGORIES

def classify_sample(filename, categories=None):
    name = filename.lower()
    categories = categories or DEFAULT_CATEGORIES
    for category, keywords in categories.items():
        for keyword in keywords:
            if keyword in name:
                return category
    return "Uncategorized"
