"""Check documentary invariants; does not certify research or originality."""
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
required = [
    'latex/main.tex', 'research/README.md', 'research/venue.md',
    'research/plan.md', 'research/evidence/repository-audit.md',
    'LICENSE-POLICY.md', 'docs/decisoes/2026-10-08-enquadramento.md',
]
for name in required:
    assert (ROOT / name).is_file(), f'Missing: {name}'
with (ROOT / 'research/evidence/claims.csv').open(newline='') as stream:
    rows = list(csv.DictReader(stream))
assert len({row['id'] for row in rows}) == len(rows), 'Duplicate evidence IDs'
for row in rows:
    source = row['source']
    if source != 'none' and not source.startswith('https://'):
        assert (ROOT / source).is_file(), f'Broken source: {source}'
assert any(row['kind'] == 'educational_result' and row['status'] == 'not_established' for row in rows)
tex = (ROOT / 'latex/main.tex').read_text()
assert 'pesquisa em planejamento' in tex
assert '\\bibitem{lelli2024}' in tex
print('PASS: required documents, evidence IDs, local sources and planning status')
