const BASE_URL = 'http://localhost:3000/api/v1';
const API_KEY = '257f5a2fe594c50eb6b23045aada2c34568adcca2eab4543e8798fe4049af114';

function getQuestions () {
  const headers = new Headers({
    'Authorization':`Apikey ${API_KEY}`
  });
  return fetch(`${BASE_URL}/questions`, {headers})
    .then(res => res.json());
}

function getQuestion (id) {
  const headers = new Headers({
    'Authorization':`Apikey ${API_KEY}`
  });
  return fetch(`${BASE_URL}/questions/${id}`, {headers})
  // A better practice when handling response from fetch
  // is to check its status if it was successful (Status: 200 OK)
  // before parsing as json with (res.json()).
    .then(res => res.json());
}

function renderQuestionSummary (question) {
  return `
    <div class="question-summary">
      <a href class="question-link" data-id="${question.id}">
        ${question.title}
      </a>
    </div>
  `;
}

function renderQuestionList (questions) {
  return questions.map(renderQuestionSummary).join('');
}

function renderQuestionDetails (question) {
  return `
    <a href class='back-button'>Back</a>
    <h1>${question.title}</h1>
    <p>${question.body}</p>
    <p><strong>Author:</strong> ${question.author_full_name}</p>
    <h2>Answers</h2>
    ${renderAnswerList(question.answers)}
  `;
}

function renderAnswerList (answers) {
  return `
    <ul class="answer-list">
      ${
        answers.map(({body}) => `<li>${body}</li>`).join('')
      }
    </ul>
  `
}


document.addEventListener('DOMContentLoaded', () => {
  const questionList = document.querySelector('#questions-list');
  const questionDetails = document.querySelector('#question-details');

  getQuestions().then(questions => {
    questionList.innerHTML = renderQuestionList(questions);
  })

  questionList.addEventListener('click', event => {
    const {target} = event;
    if (target.matches('a.question-link')) {
      event.preventDefault();
      const id = target.getAttribute('data-id');
      getQuestion(id)
        .then(question => {
          questionList.classList.add('hidden');
          questionDetails.innerHTML = renderQuestionDetails(question);
        });
    }
    if (target.matches('a.back-button')) {
      event.preventDefault();
      questionList.classList.remove('hidden');
      questionDetails.classList.add('hidden');
    }
  });
});







/* */
