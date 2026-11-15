from playwright.sync_api import sync_playwright
from pathlib import Path
import base64, re, shutil

ROOT=Path(__file__).resolve().parents[1] / 'orbital' / 'public'
html=(ROOT/'index.html').read_text()
math_src=(ROOT/'orbital-math.mjs').read_text()
details_src=(ROOT/'object-details.mjs').read_text()
def data_url(src):
    return 'data:text/javascript;base64,'+base64.b64encode(src.encode()).decode()
math_url=data_url(math_src)
details_src=details_src.replace("from './orbital-math.mjs'", f"from '{math_url}'")
details_url=data_url(details_src)
html=html.replace("import { orbitalPosition, createDemoStars } from './orbital-math.mjs';", f"import {{ orbitalPosition, createDemoStars }} from '{math_url}';")
html=html.replace("import { buildPlanetInspection, buildSunInspection, buildLabInspection, labScenePosition } from './object-details.mjs';", f"import {{ buildPlanetInspection, buildSunInspection, buildLabInspection, labScenePosition }} from '{details_url}';")
# Test-only bridge exposes live in-module objects to the browser smoke test.
_bridge="window.__orbitalTestState = { get bodies(){ return bodies; }, get labStars(){ return labStars; }, get sun(){ return SUN; } };\n</script>"
_head,_sep,_tail=html.rpartition('</script>')  # inject into the main module script (the last one)
html=_head+_bridge+_tail

errors=[]
with sync_playwright() as p:
    launch_options={'headless':True,'args':['--no-sandbox','--disable-dev-shm-usage']}
    chromium_path=shutil.which('chromium') or shutil.which('chromium-browser') or shutil.which('google-chrome') or shutil.which('chrome')
    if chromium_path: launch_options['executable_path']=chromium_path
    browser=p.chromium.launch(**launch_options)
    page=browser.new_page(viewport={'width':1440,'height':1000}, device_scale_factor=1)
    page.on('pageerror', lambda exc: errors.append(str(exc)))
    page.set_content(html, wait_until='load')
    page.wait_for_selector('#simulationCanvas')
    page.wait_for_timeout(600)
    assert page.locator('canvas').count()==1
    assert page.locator('.mode-btn').count()==0
    assert page.get_by_text('Campo astronómico').count()==0
    assert page.locator('#catalogControls').count()==0
    assert page.locator('#labRows [data-lab-index]').count()==180

    # Selecting the Sun via list and direct canvas hit-test.
    page.locator('[data-sun]').click()
    assert page.locator('#selectionName').inner_text()=='Sun'
    assert page.locator('#selectionDetails').get_by_text('Spectral class').count()==1
    rect=page.locator('#simulationCanvas').bounding_box()
    page.mouse.click(rect['x']+rect['width']/2, rect['y']+rect['height']/2)
    assert page.locator('#selectionName').inner_text()=='Sun'

    # Press directly on every planet orb in the canvas and verify its full ficha.
    for planet_name, display_name in [('Mercury','Mercury'),('Venus','Venus'),('Earth','Earth'),('Mars','Mars'),('Jupiter','Jupiter'),('Saturn','Saturn')]:
        point=page.evaluate("name => { const body=window.__orbitalTestState.bodies.find(item=>item.name===name); return body?{x:body._screen.x,y:body._screen.y}:null; }", planet_name)
        assert point is not None, f'{planet_name} has no canvas point'
        rect=page.locator('#simulationCanvas').bounding_box()
        page.mouse.click(rect['x']+point['x'], rect['y']+point['y'])
        assert page.locator('#selectionName').inner_text()==display_name, f'canvas click did not select {planet_name}'
        assert page.evaluate("document.querySelector('#controlPanel').scrollTop") == 0, 'detail panel did not return to the ficha at top'
        details=page.locator('#selectionDetails').inner_text()
        assert 'Mass (10²⁴ kg)' in details and 'Computed orbital period' in details and 'Escape velocity' in details

    # Press directly on a synthetic lab orb in the canvas and verify its complete ficha.
    lab_point=page.evaluate("() => { const star=window.__orbitalTestState.labStars.find(item=>item._screen); return star?{id:star.id,x:star._screen.x,y:star._screen.y}:null; }")
    assert lab_point is not None, 'No visible laboratory orb found on canvas'
    rect=page.locator('#simulationCanvas').bounding_box()
    page.mouse.click(rect['x']+lab_point['x'], rect['y']+lab_point['y'])
    assert page.locator('#selectionName').inner_text()==lab_point['id']
    details=page.locator('#selectionDetails').inner_text()
    assert 'Simulated temperature' in details and 'Simulated distance' in details and 'Simulated color index' in details

    page.locator('#spectralFilter').select_option(label='Red dwarf')
    assert int(page.locator('#labCount').inner_text()) > 0
    page.locator('#showLabObjects').uncheck()
    assert page.locator('#summaryLab').inner_text()=='Hidden'
    page.locator('#showLabObjects').check()
    page.locator('#resetLab').click()
    assert page.locator('#labCount').inner_text()=='180'
    page.screenshot(path=str(Path(__file__).resolve().parents[1] / 'orbital-integrated-desktop.png'), full_page=True)
    assert not errors, errors

    mobile=browser.new_page(viewport={'width':390,'height':844}, device_scale_factor=1)
    mobile.on('pageerror', lambda exc: errors.append(str(exc)))
    mobile.set_content(html, wait_until='load')
    mobile.wait_for_timeout(400)
    overflow=mobile.evaluate('document.documentElement.scrollWidth > document.documentElement.clientWidth')
    assert not overflow, 'mobile horizontal overflow'
    mobile.locator('[data-planet="Mars"]').click()
    assert mobile.locator('#selectionName').inner_text()=='Mars'
    mobile_detail_box=mobile.locator('#selectionPanel').bounding_box()
    assert mobile_detail_box['y'] < 844 and mobile_detail_box['y'] >= -10, 'mobile ficha was not brought into view'
    mobile.screenshot(path=str(Path(__file__).resolve().parents[1] / 'orbital-integrated-mobile.png'), full_page=True)
    assert not errors, errors
    browser.close()

print('Browser smoke passed: one Canvas 2D; no catalog mode; direct canvas hit-tests for Sun, all six planets and a synthetic lab orb; complete detail fichas; filter, show/hide, reset; mobile layout; zero page errors.')
