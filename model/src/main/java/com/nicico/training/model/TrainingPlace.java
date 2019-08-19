package com.nicico.training.model;


import com.nicico.training.model.enums.EArrangementType;
import com.nicico.training.model.enums.EPlaceType;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain=true)
@EqualsAndHashCode(of={"id"})
@Entity
@Table(name="tbl_training_place",schema = "TRAINING")
public class TrainingPlace extends  Auditable{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE,generator = "training_place_seq")
    @SequenceGenerator(name = "training_place_seq",sequenceName = "seq_training_place_id",allocationSize = 1)
    @Column(name = "id",precision = 0)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "n_capacity")
    private Integer capacity;

    @Column(name = "e_place_type",insertable = false, updatable = false)
    private EPlaceType ePlaceType;

    @Column(name = "e_place_type",insertable = false, updatable = false)
    private Integer ePlaceTypeId;

    @Column(name = "e_place_type",insertable = false, updatable = false)
    private EArrangementType eArrangementType;

    @Column(name = "e_place_type",insertable = false, updatable = false)
    private Integer eArrangementTypeId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_training_place_equipment",schema = "training",
            joinColumns={@JoinColumn(name = "f_training_place_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn( name = "f_equipment_id", referencedColumnName = "id")})
    private Set<Equipment> equipmentSet;

    @Column(name = "c_description", length = 500)
    private String description;


}
