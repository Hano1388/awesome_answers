const BASE_URL = 'http://localhost:3000/api/v1';
const API_KEY = 'eb997cf99d00ee0117002a5305736dbfad3d08cb147b5fcb140c2707b8641b6d'

function getQuestions () {
  const headers = new Headers({
    'Authorization':`Apikey ${API_KEY}`
  });
  return fetch(`${BASE_URL}/questions`, {headers})
    .then(res => res.json());
}
// getQuestions().then(console.info(console.table))

function renderQuestionSummary (question) {
  return `
    <div class="question-summary">
    ${question.title}
    </div>
  `;
}

function renderQuestionList (question) {
  return question.map(renderQuestionSummary);
}

document.addEventListener('DOMContentLoaded', () => {
  const questionList = document.querySelector('#questions-list');

  getQuestions().then(questions => {
    questionList.innerHTML = renderQuestionList(questions);
  })
})
