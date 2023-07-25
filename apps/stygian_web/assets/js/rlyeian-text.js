export const rlyeianAnimations = () => {
  rlyeianDivAnimation("rlyeian_text_div_1", 1000)
  rlyeianDivAnimation("rlyeian_text_div_2", 1500)
  rlyeianDivAnimation("rlyeian_text_div_3", 2000)
}

const widthOffset = 300
const heightOffset = 800
const textChangeDelayMs = 250

const rlyeianDivAnimation = (divId, positionDelay) => {
  const rlyeianDiv = document.querySelector(`#${divId}`)
  console.debug("div" + divId, rlyeianDiv)
  let firstInterval = undefined
  let secondInterval = undefined

  const checkIntervals = () => {
    const rlyeianDiv = document.querySelector(`#${divId}`)
    
    if (rlyeianDiv == null) {
      if (firstInterval != null) clearInterval(firstInterval)
      if (secondInterval != null) clearInterval(secondInterval)
    }
  }

  if (rlyeianDiv != null) {
    firstInterval = setInterval(() => {
      checkIntervals()

      const textSize = Math.random() * 35
      rlyeianDiv.style.fontSize = `${textSize + 5}px`
      
      const text = generateRandomWord()

      rlyeianDiv.innerHTML = text;
    }, textChangeDelayMs);

    secondInterval = setInterval(() => {
      checkIntervals()

      const [width, height] = [
        window.screen.availWidth - widthOffset,
        window.screen.availHeight - heightOffset
      ].map(d => Math.random() * d)

      rlyeianDiv.style.left = `${width}px`;
      rlyeianDiv.style.top = `${height}px`;
    }, positionDelay);
  }
}

const generateRandomWord = () => {
  let char = ""

  for (let i = 0; i < 10; i++) {
    char += generateRandomCharacter()
  }

  return char
}

const generateRandomCharacter = () => {
  const rand = Math.random() * 27
  return String.fromCharCode(97 + rand)
}
