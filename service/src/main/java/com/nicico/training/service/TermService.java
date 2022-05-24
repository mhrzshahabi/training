package com.nicico.training.service;

import com.ibm.icu.util.PersianCalendar;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TermDTO;
import com.nicico.training.iservice.ITermService;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.Term;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.TermDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@RequiredArgsConstructor
public class TermService implements ITermService {
    private final TermDAO termDAO;
    private final ModelMapper mapper;
    private final TclassDAO tclassDAO;

    @Transactional(readOnly = true)
    @Override
    public TermDTO.Info get(Long id) {
        final Optional<Term> optionalTerm = termDAO.findById(id);
        final Term term = optionalTerm.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        return mapper.map(term, TermDTO.Info.class);
    }

    @Transactional
    @Override
    public List<TermDTO.Info> list() {
        List<Term> termList = termDAO.findAll();
        return mapper.map(termList, new TypeToken<List<TermDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public TermDTO.Info create(TermDTO.Create request) {
        Term term = mapper.map(request, Term.class);

        return mapper.map(termDAO.saveAndFlush(term), TermDTO.Info.class);
    }

    @Transactional
    @Override
    public TermDTO.Info update(Long id, TermDTO.Update request, HttpServletResponse response) {
        if (tclassDAO.existsByTermId(request.getId()))
        {
            try {
                response.sendError(405, null);
                return null;
            } catch (IOException e) {
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }

        Optional<Term> optionalTerm = termDAO.findById(id);
        Term currentTerm = optionalTerm.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        Term term = new Term();
        mapper.map(currentTerm, term);
        mapper.map(request, term);
        return mapper.map(termDAO.saveAndFlush(term), TermDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id,HttpServletResponse response) {
        if (tclassDAO.existsByTermId(id))
        {
            try {
                response.sendError(405, null);
                return;
            } catch (IOException e) {
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }

        termDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(TermDTO.Delete request) {
        final List<Term> jobList = termDAO.findAllById(request.getIds());
        termDAO.deleteAll(jobList);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<TermDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(termDAO, request, term -> mapper.map(term, TermDTO.Info.class));
    }

    @Transactional
    @Override
    public String checkForConflict(String sData, String eData) {
        List<String> list = termDAO.findConflict(sData, eData);
        if (list.size() > 0)
            return list.get(0);
        else
            return (null);
    }

    @Transactional
    @Override
    public String checkConflictWithoutThisTerm(String sData, String eData, Long id) {
        List<String> list = termDAO.findConflictWithoutThisTerm(sData, eData, id);
        if (list.size() > 0)
            return list.get(0);
        else
            return (null);
    }

    @Transactional
    @Override
    public String LastCreatedCode(String code) {
        List<Term> termList = termDAO.findByCodeStartingWith(code);
        int max = 0;
        if (termList.size() == 0)
            return "0";
        for (Term term : termList) {
            if (max < Integer.parseInt(term.getCode().substring(5, 6)))
                max = Integer.parseInt(term.getCode().substring(5, 6));
        }
        return String.valueOf(max);
    }

    @Transactional
    @Override
    public TotalResponse<TermDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(termDAO, request, term -> mapper.map(term, TermDTO.Info.class));
    }

    @Transactional
    @Override
    public TotalResponse<TermDTO.Year> ySearch(NICICOCriteria request) {
        request.setDistinct(true);
        List<String> years = termDAO.getYearsList();
        TotalResponse<TermDTO.Year> response = new TotalResponse<>(new GridResponse<>());
        response.getResponse().setData(new ArrayList<TermDTO.Year>());
        for (String year : years) {
            TermDTO.Year newYear = new TermDTO.Year();
            newYear.setYear(year);
            response.getResponse().getData().add(newYear);
        }
        response.getResponse().getData().sort(Comparator.comparing(TermDTO.Year::getYear).reversed());
        return response;
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TermDTO.Info> searchByYear(SearchDTO.SearchRq request, String year) {
        SearchDTO.CriteriaRq criteriaRq1 = makeNewCriteria("startDate", year, EOperator.contains, null);
        SearchDTO.CriteriaRq criteriaRq2 = makeNewCriteria("endDate", year, EOperator.contains, null);
        List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
        criteriaRqList.add(criteriaRq1);
        criteriaRqList.add(criteriaRq2);
        request.setCriteria(new SearchDTO.CriteriaRq());
        request.getCriteria().setCriteria(criteriaRqList);
        request.getCriteria().setOperator(EOperator.or);
        return SearchUtil.search(termDAO, request, term -> mapper.map(term, TermDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TermDTO.Info> searchYearCurrentTerm(String year) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String todayDate = DateUtil.convertMiToKh(dateFormat.format(date));
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        if(year.equalsIgnoreCase(todayDate.substring(0,4))) {
            SearchDTO.CriteriaRq criteriaRq1 = makeNewCriteria("startDate", year, EOperator.contains, null);
            SearchDTO.CriteriaRq criteriaRq2 = makeNewCriteria("startDate", todayDate, EOperator.lessOrEqual, null);
            SearchDTO.CriteriaRq criteriaRq3 = makeNewCriteria("endDate", todayDate, EOperator.greaterOrEqual, null);
            List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
            criteriaRqList.add(criteriaRq1);
            criteriaRqList.add(criteriaRq2);
            criteriaRqList.add(criteriaRq3);
            request.setCriteria(new SearchDTO.CriteriaRq());
            request.getCriteria().setCriteria(criteriaRqList);
            request.getCriteria().setOperator(EOperator.and);
        }
        else{
            SearchDTO.CriteriaRq criteriaRq1 = makeNewCriteria("startDate", year, EOperator.contains, null);
            List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
            criteriaRqList.add(criteriaRq1);
            request.setCriteria(new SearchDTO.CriteriaRq());
            request.getCriteria().setCriteria(criteriaRqList);
            request.getCriteria().setOperator(EOperator.and);
        }
        return SearchUtil.search(termDAO, request, term -> mapper.map(term, TermDTO.Info.class));
    }

    public SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        return BaseService.makeNewCriteria(fieldName, value, operator, criteriaRqList);
    }

    @Transactional(readOnly = true)
    @Override
    public List<TermDTO.Years> years() {
        List<String> years = termDAO.getYearsFromStartDate();

        List<TermDTO.Years> yearList = new ArrayList<>(years.size());

        for (String year : years)
        {
            yearList.add(new TermDTO.Years(year));
        }

        return yearList;
    }


}



